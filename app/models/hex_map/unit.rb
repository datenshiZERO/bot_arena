module HexMap
  class Unit
    attr_reader :damage, :range_min, :range_max, :evade, :move, :defense, :accuracy, :hp_max
    attr_accessor :id, :hp, :team, :target, :tile, :kills, :assists, :spawn_point

    def initialize(unit)
      @unit = unit
      @hp = unit.unit_template.hp
      @evade = unit.unit_template.evade
      @move = unit.unit_template.move
      @defense = unit.unit_template.defense
      @damage = 0
      @accuracy = 0
      @range_min = 0
      @range_max = 0
      @kills = []
      @assists = []

      @weapon, @armor, @mobility = 
        if unit.is_a? BattleBot
          template = unit.unit_template
          [template.weapon_default, template.armor_default, template.mobility_default]
        else
          # unit is a player unit
          [
           unit.weapons.empty? ? nil : unit.weapons.first,
           unit.armors.empty? ? nil : unit.armors.first,
           unit.mobility_items.empty? ? nil : unit.mobility_items.first
          ]
        end
                                  
      if @weapon.present?
        @damage = @weapon.damage
        @accuracy = @weapon.accuracy
        @range_min = @weapon.range_min
        @range_max = @weapon.range_max
        @hp += @weapon.bonus_hp
        @evade += @weapon.bonus_evade
        @move += @weapon.bonus_move
        @defense += @weapon.bonus_defense
        @accuracy += @weapon.bonus_accuracy
      end
      if @armor.present?
        @hp += @armor.bonus_hp
        @evade += @armor.bonus_evade
        @move += @armor.bonus_move
        @defense += @armor.bonus_defense
        @accuracy += @armor.bonus_accuracy
      end
      if @mobility.present?
        @hp += @mobility.bonus_hp
        @evade += @mobility.bonus_evade
        @move += @mobility.bonus_move
        @defense += @mobility.bonus_defense
        @accuracy += @mobility.bonus_accuracy
      end
      @hp_max = @hp
    end

    def details
      {
        name: name,
        team: @team,
        template: @unit.unit_template.name,
        template_id: @unit.unit_template.id,
        hp: @hp_max,
        evade: @evade,
        move: @move,
        defense: @defense,
        damage: @damage,
        accuracy: @accuracy,
        range_max: @range_max,
        range_min: @range_min,
        spawn_point: [@spawn_point.q, @spawn_point.r]
      }

      # if present, merge
        #weapon: weapon name,
        #weapon_id: weapon.id,
        #armor: armor,
        #armor_id: armor.id,
        #mobility: mobility,
        #mobility_id: mobility.id,
    end

    def name
      if @unit.is_a? BattleBot
        "Bot#{@id}"
      else
        @unit.name
      end
    end

    def alive?
      @hp > 0
    end

    def dead?
      !alive?
    end

    def real_id
      @unit.id
    end

    def move_to(target)
      origin = @tile
      target.unit = self
      @tile = target
      origin.unit = nil
    end

  end
end

