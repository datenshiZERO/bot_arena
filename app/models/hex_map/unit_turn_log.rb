module HexMap
  class UnitTurnLog
    def initialize(unit)
      @id = unit.id
      @attacked = false
    end

    def log_target(target)
      @target = target
    end

    def log_moves(path)
      @path = path
    end

    def log_new_target(new_target)
      @new_target = new_target
    end

    def log_attack(hit, damage, kill)
      @attacked = true
      @hit = hit
      @damage = damage
      @kill = kill
    end

    def to_hash
      log = { 
        id: @id,
        path: @path
      }
      unless @target.nil?
        log[:target] = @target.id
      end
      if @attacked == true
        log[:attack] = {
          hit: @hit,
          damage: @damage,
          kill: @kill
        }
        unless @new_target.nil?
          log[:attack][:new_target] = @new_target.id
        end
      end
      log
    end
  end
end
