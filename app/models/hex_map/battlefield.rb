module HexMap
  class Battlefield
    def new(arena)
      @arena = arena
      setup_map
    end

    def setup_map
      @map = []
      @spawn_points = {}
      @arena.columns.times do |q|
        row = []
        @arena.rows.times do |r|
          value = @arena.processed_layout[q][r]
          wall = value == "*"
          tile = HexMap::Tile.new(self, q, r, wall)
          unless ["*", "."].include? value
            unless @spawn_points.has_key? value
              @spawn_points[value] = []
            end
            @spawn_points[value] < [q, r]
          end
          row << tile
        end
        @map << row
      end
    end

    def get_tile(q, r)
      return nil if (q < 0 || r < 0 || q > @arena.columns || r > @arena.rows)

      @map[q][r]
    end
  end
end
