module HexMap
  class Battlefield
    def initialize(arena, unit_ids)
      @arena = arena
      setup_units(unit_ids)
      setup_bots
      setup_map
    end

    def setup_units(unit_ids)
      units = Unit.where(id: unit_ids)
      if units.count < @arena.players_max
        filler = @arena.battle_bots.where(filler: true)
        units += (1..(@arena.players_max - units.count)).map do
          filler.sample
        end
      end

      @units = units.map { |u| HexMap::Unit.new(u) }.shuffle
    end

    def setup_bots
      bots = @arena.battle_bots.where(filler: false)
      @bots = bots.inject([]) do |memo, bot|
        memo += [bot] * bot.count
        memo
      end
    end

    def setup_map
      @map = []
      @spawn_points = {}
      unit_idx = 0
      bot_idx = 0
      @arena.columns.times do |q|
        row = []
        @arena.rows.times do |r|
          value = @arena.processed_layout[q][r]
          wall = value == "*"
          tile = HexMap::Tile.new(self, q, r, wall)
          unless ["*", "."].include? value
            if value == "X"
              # place bot
              tile.unit = @bots[bot_idx]
              bot_idx += 1
            else
              # place unit
              tile.unit = @units[unit_idx]
              unit_idx += 1
            end
            if tile.unit.present?
              tile.unit.team = value
            end
          end
          row << tile
        end
        @map << row
      end
    end


    def process_battle

    end

    def get_tile(q, r)
      return nil if (q < 0 || r < 0 || q > @arena.columns || r > @arena.rows)

      @map[q][r]
    end
  end
end
