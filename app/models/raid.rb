class Raid < ActiveRecord::Base
  belongs_to :user
  belongs_to :quest

  validates :quest, presence: true
  validates :user, presence: true

  validate :check_stage_and_active, if: "quest.present?"
  validate :at_least_one_unit, :units_must_be_available, :check_duplicate_units
  after_create :dive

  def party_snapshot
    @party_snapshot ||= JSON.parse(raid_log)["party"]
    @party_snapshot
  end
  private

  def check_stage_and_active
    if quest.stage > user.stage || !quest.active
      errors.add(:quest_id, "is invalid")
    end
  end
 
  def at_least_one_unit
    if [unit_1_id, unit_2_id, unit_3_id, unit_4_id, unit_5_id, unit_6_id].compact.empty?
      errors.add(:unit_1_id, "can't be blank")
    end
  end

  def units_must_be_available
    if unit_1_id.present?
      unit = user.units.find(unit_1_id)
      if unit.arena.present? || unit.fired
        errors.add(:unit_1_id, "is not available for a raid")
      end
    end
    if unit_2_id.present?
      unit = user.units.find(unit_2_id)
      if unit.arena.present? || unit.fired
        errors.add(:unit_2_id, "is not available for a raid")
      end
    end
    if unit_3_id.present?
      unit = user.units.find(unit_3_id)
      if unit.arena.present? || unit.fired
        errors.add(:unit_3_id, "is not available for a raid")
      end
    end
    if unit_4_id.present?
      unit = user.units.find(unit_4_id)
      if unit.arena.present? || unit.fired
        errors.add(:unit_4_id, "is not available for a raid")
      end
    end
    if unit_5_id.present?
      unit = user.units.find(unit_5_id)
      if unit.arena.present? || unit.fired
        errors.add(:unit_5_id, "is not available for a raid")
      end
    end
    if unit_6_id.present?
      unit = user.units.find(unit_6_id)
      if unit.arena.present? || unit.fired
        errors.add(:unit_6_id, "is not available for a raid")
      end
    end
  end

  def check_duplicate_units
    if unit_2_id.present?
      if unit_2_id == unit_1_id
        errors.add(:unit_2_id, "is a duplicate")
      end
    end
    if unit_3_id.present?
      if [unit_1_id, unit_2_id].compact.include? unit_3_id
        errors.add(:unit_3_id, "is a duplicate")
      end
    end
    if unit_4_id.present?
      if [unit_1_id, unit_2_id, unit_3_id].compact.include? unit_4_id
        errors.add(:unit_4_id, "is a duplicate")
      end
    end
    if unit_5_id.present?
      if [unit_1_id, unit_2_id, unit_3_id, unit_4_id].compact.include? unit_5_id
        errors.add(:unit_5_id, "is a duplicate")
      end
    end
    if unit_6_id.present?
      if [unit_1_id, unit_2_id, unit_3_id, unit_4_id, unit_5_id].compact.include? unit_6_id
        errors.add(:unit_6_id, "is a duplicate")
      end
    end
  end

  def dive
    dive = Dungeon::Dive.new(self)
    dive.process_raid
    true
  end
end
