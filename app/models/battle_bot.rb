class BattleBot < ActiveRecord::Base
  belongs_to :arena

  def unit_template
    UnitTemplate.find(template_slug)
  end

  def weapon
    unit_template.weapon_default
  end

  def armor
    unit_template.armor_default
  end

  def mobility_item
    unit_template.mobility_default
  end

  include BattleUnit
end
