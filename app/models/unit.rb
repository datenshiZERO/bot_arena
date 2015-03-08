class Unit < ActiveRecord::Base
  belongs_to :user
  belongs_to :arena
  has_many :unit_battle_outcomes

  #TODO limit to one weapon/armor/mobility
  has_many :user_equipments

  attr_accessor :weapon_id, :armor_id, :mobility_id

  validates :name, presence: true

  validate :verify_equipment

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

  def setup_equipment_ids
    @weapon_id ||= weapon.present? ? weapon.id : nil
    @armor_id ||= armor.present? ? armor.id : nil
    @mobility_id ||= mobility_item.present? ? mobility_item.id : nil
  end

  def total_points
    [unit_template, weapon, armor, mobility_item].compact.sum(&:points)
  end

  def max_hp
    unit_template.hp + 
      [weapon, armor, mobility_item].compact.sum(&:bonus_hp)
  end

  def dropdown_text
    "#{name} (#{unit_template.name}) - #{total_points} points - HP: #{eff_hp} - MV: #{eff_move} - #{eff_evade}/#{eff_defense} - #{eff_damage}/#{eff_accuracy}/#{ranged_text}"
  end

  def ranged_text
    eff_range_max > 1 ? "Ranged" : "Melee"
  end
  include BattleUnit

  def verify_equipment
    current_weapon_id = weapon.present? ? weapon.id : nil
    if @weapon_id.present? && @weapon_id.to_i != current_weapon_id
      i = user.user_equipment.where(unit: nil).find(@weapon_id)
      if i.slot != "weapon" || i.points > unit_template.weapon_points
        errors.add(:weapon_id, "Invalid weapon selected")
      end
    end

    current_armor_id = armor.present? ? armor.id : nil
    if @armor_id.present? && @armor_id.to_i != current_armor_id
      i = user.user_equipment.where(unit: nil).find(@armor_id)
      if i.slot != "armor" || i.points > unit_template.armor_points
        errors.add(:armor_id, "Invalid armor selected")
      end
    end

    current_mobility_id = mobility_item.present? ? mobility_item.id : nil
    if @mobility_id.present? && @mobility_id.to_i != current_mobility_id
      i = user.user_equipment.where(unit: nil).find(@mobility_id)
      if i.slot != "mobility" || i.points > unit_template.mobility_points
        errors.add(:armor_id, "Invalid mobility item selected")
      end
    end
  end

  def update_equipment
    self.user_equipment_ids = [@weapon_id, @armor_id, @mobility_id].compact
    if arena.present? && 
        (total_points < arena.points_min || arena.points_max > total_points)
      self.arena = nil
    end
    self.save
  end
end
