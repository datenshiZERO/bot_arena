module HexMap
  class Tile
    attr_reader :q, :r, :x, :y, :z
    attr_accessor :unit

    def initialize(battlefield, q, r, wall = false)
      @battlefield = battlefield
      @q = q
      @r = r
      @x, @y, @z = HexMap::Utils.offset_to_cube(q, r)
      @unit = nil
      @wall = wall
    end

    def neighbors
      if r % 2 == 0
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
          @battlefield.get_3d_tile(@x + range, @y - (range - a), @z - a),
          @battlefield.get_3d_tile(@x - a, @y + range, @z - (range - a)),
          @battlefield.get_3d_tile(@x - (range - a), @y - a, @z + range),
          @battlefield.get_3d_tile(@x - range, @y + range - a, @z + a),
          @battlefield.get_3d_tile(@x + a, @y - range, @z + range - a),
          @battlefield.get_3d_tile(@x + range - a, @y + a, @z - range)
        ]
      end.flatten.compact 
    end

    def landable_tiles_at_range(range)
      tiles_at_range(range).select { |t| t.empty_space? }
    end

    def passable_neighbors(unit)
      neighbors.select { |n| n.passable?(unit) }
    end

    def passable?(moving_unit)
      return true if empty_space?
      !wall? && (@unit.team == moving_unit.team) 
    end

    def empty_space?
      !wall? && @unit == nil
    end

    def wall?
      @wall
    end
  end
end
