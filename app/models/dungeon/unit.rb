module Dungeon
  class Unit
    attr_reader :template, :monster, :move, :evade, :defense, :damage, 
      :accuracy, :ranged

    attr_accessor :hp, :front, :id

    def initialize(id_or_slug, front = true)
      if id_or_slug.is_a? String
        actor = Monster.find(id_or_slug)
        @hp = actor.hp
        @move = actor.move
        @evade = actor.evade
        @defense = actor.defense
        @damage = actor.damage
        @accuracy = actor.accuracy
        @ranged = actor.ranged
        @monster = true
      else
        actor = ::Unit.find(id_or_slug)
        @hp = actor.eff_hp
        @move = actor.eff_move
        @evade = actor.eff_evade
        @defense = actor.eff_defense
        @damage = actor.eff_damage
        @accuracy = actor.eff_accuracy
        @ranged = actor.eff_range_max > 1
        @monster = false
      end
      @template = actor
      @front = front
      @name = actor.name
      @icon_class = actor.icon_class
    end

    def details
      hash = {
        name: @name,
        hp: @hp,
        front: @front,
        move: @move,
        evade: @evade,
        defense: @defense,
        damage: @damage,
        accuracy: @accuracy,
        ranged: @ranged,
        icon_class: @icon_class
      }

      hash
    end

    def alive?
      @hp > 0
    end

    def dead?
      !alive?
    end
    
  end
end
