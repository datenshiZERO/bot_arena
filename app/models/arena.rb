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
    # called at start of hour
    # get all queueable arenas (ie. with bots)
    # queue intervals for each
  end

  def prepare_battles
    groups = group_participants
    groups.each do |unit_ids|
      PrepareBattlesJob.perform_later(self, unit_ids)
    end
  end

  def group_participants
    # find all current participants
    # shuffle them into groups
    # return array of id arrays
  end

  def commence_battle(unit_ids)
    units = Unit.where(id: unit_ids)
    valid_units = []
    units.each do |unit|
      if unit.total_points < points_min || points_max < unit.total_points
        # Eject from arena
        unit.arena = nil
        unit.save
      else
        valid_units << unit
      end
    end
    return false if valid_units.empty?

    battlefield = HexMap::Battlefield.new(self, valid_units)
    battlefield.process_battle

    true
  end
end
