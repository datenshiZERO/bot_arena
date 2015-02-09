module HexMap
  class UnitTurnLog
    attr_accessor :id, :target, :move, :attack

    def initialize(unit)
      @id = unit.id
    end

    def log_target(target)
      @target = target
    end

    def log_move(q, r)
      @move = [q, r]
    end
  end
end
