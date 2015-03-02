class Unit < ActiveRecord::Base
  belongs_to :user
  belongs_to :arena
  has_many :unit_battle_outcomes

  #TODO limit to one weapon/armor/mobility
  has_many :user_equipments

  def unit_template
    UnitTemplate.find(template_slug)
  end

  def weapon
    weapons = user_equipments.select { |e| e.slot == "weapon" }
    return nil if weapons.empty?
    weapons.first
  end

  def armor
    armors = user_equipments.select { |e| e.slot == "armor" }
    return nil if armors.empty?
    armors.first
  end

  def mobility_item
    mobility_items = user_equipments.select { |e| e.slot == "mobility" }
    return nil if mobility_items.empty?
    mobility_items.first
  end

  def total_points
    [unit_template, weapon, armor, mobility_item].compact.sum(&:points)
  end

  def max_hp
    unit_template.hp + 
      [weapon, armor, mobility_item].compact.sum(&:bonus_hp)
  end

  def icon_class
    ""
  end

  def weapon_icon_class
    weapon.present? ? weapon.icon_class : ""
  end

  def armor_icon_class
    armor.present? ? armor.icon_class : ""
  end

  def mobility_icon_class
    mobility_item.present? ? mobility_item.icon_class : ""
  end

  include BattleUnit
end
