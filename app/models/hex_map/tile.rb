module HexMap
  class Tile
    attr_reader :q, :r, :x, :y, :z
    attr_accessor :unit

    def new(battlefield, q, r, wall = false)
      @battlefield = battlefield
      @q = q
      @r = r
      @x, @y, @z = HexMap::Utils.offset_to_cube(q, r)
      @unit = nil
      @wall = wall
    end

    def neighbors
      n = if n % 2 == 0
        [
          @battlefield.get_tile(@q + 1, @r),
          @battlefield.get_tile(@q, @r - 1),
          @battlefield.get_tile(@q - 1, @r - 1),
          @battlefield.get_tile(@q - 1, @r),
          @battlefield.get_tile(@q - 1, @r + 1),
          @battlefield.get_tile(@q, @r + 1)
        ]
      else
        [
          @battlefield.get_tile(@q + 1, @r),
          @battlefield.get_tile(@q + 1, @r - 1),
          @battlefield.get_tile(@q, @r - 1),
          @battlefield.get_tile(@q - 1, @r),
          @battlefield.get_tile(@q, @r + 1),
          @battlefield.get_tile(@q + 1, @r + 1)
        ]
      end.compact
    end

    def tiles_at_range(range)
      (0...range).map do |a| 
        [ 
          @battlefield.get_tile(range, -(range - a), -a),
          @battlefield.get_tile(-(range - a), range, -a),
          @battlefield.get_tile(-(range - a), -a, range),
          @battlefield.get_tile(-range, range - a, a),
          @battlefield.get_tile(range - a, -range, a),
          @battlefield.get_tile(range - a, a, -range)
        ]
      end.flatten 
    end

    def landable_tiles_at_range(range)
      tiles_at_range(range).select { |t| t.empty_space }
    end

    def passable_neighbors
      neighbors.select { |n| n.passable?(self) }
    end

    def passable?(moving_unit)
      return true if empty_space?
      !wall? && (@unit.team == moving_unit.team) 
    end

    def empty_space
      !wall? && @unit == nil
    end

    def wall?
      @wall
    end
  end
end