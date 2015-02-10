module HexMap
  class UnitTurnLog
    attr_accessor :id, :target, :moves, :attack

    def initialize(unit)
      @id = unit.id
    end

    def log_target(target)
      @target = target
    end

    def log_moves(moves)
      @moves = moves
    end
  end
end
