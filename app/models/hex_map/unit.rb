module HexMap
  class Unit
    attr_reader :damage, :range_min, :range_max, :evade, :move, :defense, :accuracy, :hp_max, :bot
    attr_accessor :id, :hp, :team, :target, :tile, :kills, :assists, :spawn_point

    def initialize(unit)
      @unit = unit
      @hp = unit.eff_hp
      @evade = unit.eff_evade
      @move = unit.eff_move
      @defense = unit.eff_defense
      @damage = unit.eff_damage
      @accuracy = unit.eff_accuracy
      @range_min = unit.eff_range_min
      @range_max = unit.eff_range_max
      @weapon = unit.weapon
      @armor = unit.armor
      @mobility = unit.mobility_item
      @kills = []
      @assists = []
      @bot = unit.is_a? BattleBot
                                  
      @hp_max = @hp
    end

    def details
      hash = {
        name: name,
        team: @team,
        template_slug: @unit.template_slug,
        icon_class: @unit.unit_template.icon_class,
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

      if @weapon.present?
        hash[:weapon_icon] = @weapon.icon_class
      end
      if @armor.present?
        hash[:armor_icon] = @armor.icon_class
      end
      if @mobility.present?
        hash[:mobility_icon] = @mobility.icon_class
      end
      # if present, merge
        #weapon: weapon name,
        #weapon_id: weapon.id,
        #armor: armor,
        #armor_id: armor.id,
        #mobility: mobility,
        #mobility_id: mobility.id,
      hash
    end

    def name
      if @unit.is_a? BattleBot
        "#{Faker::Name.first_name} #{Faker::Name.last_name} (bot#{@id})"
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
      return if target == @tile
      origin = @tile
      target.unit = self
      @tile = target
      origin.unit = nil
    end

  end
end

