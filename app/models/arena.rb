class Arena < ActiveRecord::Base
  has_many :units
  has_many :battle_bots

  VALID_LAYOUT_CHARS = %w{. * A B C X}

  validate :layout_valid
  validate :bots_filled, :filler_bots_present, if: :active?
  # TODO interval checking

  def layout_valid
    flat_layout = processed_layout.flatten
    if flat_layout.count != columns * rows
      errors.add(:layout, "cell count does not match column and row count.")
    end
    if flat_layout.reject { |cell| VALID_LAYOUT_CHARS.include? cell }.count > 0
      errors.add(:layout, "includes invalid characters.")
    end
    team_a_count = flat_layout.count("A")
    team_b_count = flat_layout.count("B")
    team_c_count = flat_layout.count("C")
    teams_present = [team_a_count, team_b_count, team_c_count].reject { |x| x == 0 }.count
    if teams_present != team_count
      errors.add(:layout, "has an incorrect number of teams.")
    end
    if [team_a_count, team_b_count, team_c_count].sum != players_max
      errors.add(:layout, "has an incorrect number of players.")
    end
  end

  def bots_filled
    bots_required = processed_layout.flatten.count("X")
    bots_present = battle_bots.reject { |b| b.filler }.sum(&:count)
    if bots_required != bots_present
      errors.add(:layout, "has an incorrect number of bots.")
    end
  end

  def filler_bots_present
    # no need for fillers when there is only one player
    if players_max > 1 && battle_bots.select { |b| b.filler }.count == 0
      errors.add(:active, "can't be true unless there are filler bots.")
    end
  end

  def processed_layout
    # converts string layout (stripping whitespace) 
    # into matrix form
    layout.gsub(/\s+/, "")
      .scan(/./)
      .each_slice(columns)
      .to_a
  end

  def self.schedule_battles
    # called at start of hour via cron
    # get all queueable arenas (ie. with bots)
    Arena.includes(:units, :battle_bots).each do |arena|
      if arena.valid?
      # queue intervals for each
        times_per_hour = 60 / arena.minutes_interval
        this_hour = DateTime.now.change(min: 0, seconds: 0)
        times_per_hour.times do |minute|
          target_time = this_hour.change(min: minute * arena.minutes_interval)
          PrepareBattlesJob.set(wait_until: target_time).perform_later(arena)
        end
      end
    end
  end

  def prepare_battles
    # shuffle participants into groups
    unit_ids.shuffle.each_slice(players_max) do |selected_unit_ids|
      CommenceBattleJob.perform_later(self, selected_unit_ids)
    end
  end

  def commence_battle(unit_ids)
    #Rails.logger.error self.inspect
    #Rails.logger.error "#{points_min} #{points_max} #{id}"
    units = Unit.where(id: unit_ids)
    valid_units = []
    units.each do |unit|
      #Rails.logger.error "e #{unit.arena_id} #{id}"
      if unit.total_points < points_min || points_max < unit.total_points ||
          unit.arena_id != id
        # Eject from arena
        unit.arena = nil
        unit.save
      else
        valid_units << unit
      end
    end
    #Rails.logger.error valid_units

    unless valid_units.empty?
      battlefield = HexMap::Battlefield.new(self, valid_units)
      battlefield.process_battle
    end
    true
  end
end
