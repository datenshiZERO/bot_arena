class Arena < ActiveRecord::Base
  has_many :battle_bots

  #TODO layout checking
  # interval checking

  def processed_layout
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

  def commence_battle(units)
    battlefield = HexMap::Battlefield.new(self, unit_ids)

    battlefield.process_battle
  end
end
