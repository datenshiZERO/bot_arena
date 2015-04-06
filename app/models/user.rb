class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :units
  has_many :user_equipment
  has_many :raids
  
  validates :username, presence: true, length: { in: 3..16 }, uniqueness: true

  XP_TABLE = [
    0, 500, 2000, 5500, 10000,
    15000, 21000, 28000, 36000, 45000,
    66000, 78000, 91000, 105000, 120000,
    136000, 153000, 171000, 190000
  ]

  def current_level
    (XP_TABLE.length - 1).times do |i|
      if XP_TABLE[i] <= total_xp && total_xp < XP_TABLE[i + 1]
        return i + 1 # levels start at 1
      end
    end
    return XP_TABLE.length + 1
  end

  def xp_for_next_level
    XP_TABLE[current_level]
  end

  def max_level?
    total_xp > XP_TABLE.last
  end

  def max_units
    current_level + 1
  end

  def max_equipment
    # 3 per unit + 1 per 2 levels + 1
    (max_units * 3) + (current_level / 2) + 1
  end

  def latest_battles
    UnitBattleOutcome.joins(unit: :user).includes(battle: :arena).where("users.id = ?", id).order("created_at desc").limit(5)
  end

  def active_units
    units.where(fired: false).includes(:arena, :user_equipments)
  end

  def assigned_units
    active_units.where("arena_id is not null")
  end

  def available_unit_slots
    max_units - active_units.count
  end

  def available_equipment_slots
    max_equipment - user_equipment.count
  end

  def can_hire?(template, equipped)
    if equipped
      available_unit_slots > 0 && 
        credits >= template.full_price &&
        total_kills >= template.kill_requirement &&
        total_missions >= template.mission_requirement &&
        available_equipment_slots >= 3
    else
      available_unit_slots > 0 && 
        credits >= template.price &&
        total_kills >= template.kill_requirement &&
        total_missions >= template.mission_requirement
    end
  end

  def can_buy?(equipment)
    available_equipment_slots > 0 &&
      credits >= equipment.price
  end

  def assignable_units(arena)
    units.where(fired: false).includes(:arena, :user_equipments).select do |u|
      arena.points_min <= u.total_points && u.total_points <= arena.points_max
    end
  end

  def unlocked_quest?(quest)
    unlocked_quests[quest.stage - 1] == "Y"
  end

  def unlock_quests(completed_quest)
    prev_unlocks = unlocked_quests
    completed_quest.unlocks.each do |s|
      prev_unlocks[s - 1] = "Y"
    end
    self.unlocked_quests = prev_unlocks
  end

  def all_unlocked_quests
    Quest::QUESTS.select { |q| unlocked_quest?(q) }
  end

  def completed_quest?(quest)
    completed_quests[quest.stage - 1] == "Y"
  end

  def complete_quest(quest)
    fields = completed_quests
    fields[quest.stage - 1] = "Y"
    self.completed_quests = fields
  end
end
