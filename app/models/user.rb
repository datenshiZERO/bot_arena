class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :units
  has_many :user_equipment

  XP_TABLE = [
    0, 1000, 3000, 6000, 10000,
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
    units
  end

  def available_unit_slots
    max_units - active_units.count
  end

  def can_hire?(template)
    available_unit_slots > 0 && 
      credits >= template.price &&
      total_kills >= template.kill_requirement &&
      total_missions >= template.mission_requirement
  end
end
