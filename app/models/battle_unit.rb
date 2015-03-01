module BattleUnit
  def eff_hp
    unit_template.hp + 
      [weapon, armor, mobility_item].compact.sum(&:bonus_hp)
  end

  def eff_evade
    unit_template.evade + 
      [weapon, armor, mobility_item].compact.sum(&:bonus_evade)
  end

  def eff_move
    unit_template.move + 
      [weapon, armor, mobility_item].compact.sum(&:bonus_move)
  end

  def eff_defense
    unit_template.defense + 
      [weapon, armor, mobility_item].compact.sum(&:bonus_defense)
  end

  def eff_damage
    (weapon.present? ? weapon.damage : 0)
  end

  def eff_accuracy
    (weapon.present? ? weapon.accuracy : 0) + 
      [weapon, armor, mobility_item].compact.sum(&:bonus_accuracy)
  end

  def eff_range_min
    (weapon.present? ? weapon.range_min : 0)
  end

  def eff_range_max
    (weapon.present? ? weapon.range_max : 0)
  end
end
