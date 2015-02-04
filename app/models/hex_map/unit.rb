module HexMap
  class Unit
    attr_reader :damage, :range_min, :range_max, :evade, :move, :defense, :accuracy
    attr_accessor :hp, :team, :target

    def initialize(unit)
      @hp = unit.unit_template.hp
      @evade = unit.unit_template.evade
      @move = unit.unit_template.move
      @defense = unit.unit_template.move
      @damage = 0
      @accuracy = 0
      @range_min = 0
      @range_max = 0

      weapon, armor, mobility = 
        if unit.is_a? Unit
          [unit.weapon, unit.armor, unit.mobility]
        else
          # unit is a BattleBot
          template = unit.unit_template
          [template.weapon_default, template.armor_default, template.mobility_default]
        end
                                  
      if weapon.present?
        @damage = weapon.damage
        @accuracy = weapon.damage
        @range_min = weapon.range_min
        @range_max = weapon.range_max
        @hp += weapon.bonus_hp
        @evade += weapon.bonus_evade
        @move += weapon.bonus_move
        @defense += weapon.bonus_defense
        @accuracy += weapon.bonus_accuracy
      end
      if armor.present?
        @hp += armor.bonus_hp
        @evade += armor.bonus_evade
        @move += armor.bonus_move
        @defense += armor.bonus_defense
        @accuracy += armor.bonus_accuracy
      end
      if mobility.present?
        @hp += mobility.bonus_hp
        @evade += mobility.bonus_evade
        @move += mobility.bonus_move
        @defense += mobility.bonus_defense
        @accuracy += mobility.bonus_accuracy
      end
    end

  end
end

