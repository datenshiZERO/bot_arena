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

      @all_units = (@units + @bots).shuffle
    end

    def process_battle
      # until turn limit
      #   for each unit
      #     skip if not alive
      #     set target if target is null
      #     move to target
      #     fire at target
      # process outcome
    end

    def set_target(unit)
      # find all enemy units
      # find closest and set as target
      # add to battle log
    end

    def move_unit(unit)
      # note: hueg pathfinding code
      # find max range -> min range tiles from target, max range has higher priority
      # Dijkstra's to all target tiles
      #   store priority, distance from unit, and distance from target
      # if no path exists
      #   move towards tile closest to the target
      # if within movement, 
      #   move to closest tile that is as close to max range as possible
      # if not,
      #   move towards tile closest to max range
      # add movement to battle log
    end

    def attack(unit)
      # check if hit
      #   apply damage
      #   add target as assist
      #   if dead
      #     move target from assist to kill
      # add attack to battle log
    end

    def process_outcome
      # for each @units
      #   create unit battle outcome
      # summarize everything in battle log
    end

    def get_tile(q, r)
      return nil if (q < 0 || r < 0 || q > @arena.columns || r > @arena.rows)

      @map[q][r]
    end
  end
end
