module Dungeon
  class Unit
    attr_reader :template, :monster, :move, :evade, :defense, :damage, 
      :accuracy, :ranged

    attr_accessor :hp, :front, :id

    def initialize(actor, front = true)
      @template = actor
      @front = front
      @name = actor.name
      @icon_class = actor.icon_class
      if actor.is_a? Monster
        @hp = actor.hp
        @move = actor.move
        @evade = actor.evade
        @defense = actor.defense
        @damage = actor.damage
        @accuracy = actor.accuracy
        @ranged = actor.eff_range_max > 1
      else
        @hp = actor.eff_hp
        @move = actor.eff_move
        @evade = actor.eff_evade
        @defense = actor.eff_defense
        @damage = actor.eff_damage
        @accuracy = actor.eff_accuracy
        @ranged = actor.eff_range_max > 1
      end
    end

    def details
      hash = {
        name: @name,
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
