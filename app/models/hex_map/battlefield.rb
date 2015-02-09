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
      @team_assignments = {}
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
            tile.unit.tile = tile

            if tile.unit.present?
              tile.unit.team = value
              unless @team_assignments.has_key? value
                @team_assignments[value] = []
              end
              @team_assignments[value] << tile.unit
            end
          end
          row << tile
        end
        @map << row
      end

      @all_units = (@units + @bots).shuffle
      @all_units.each_with_index do |unit, i|
        unit.id = i
      end
    end

    def process_battle
      @battle_log = []
      @turns = 1
      while @turns <= @arena.turn_limit
        turn_log = []
        @battle_log << turn_log
        @all_units.select {|u| u.alive? }.each do |unit|
          log = HexMap::UnitTurnLog.new(unit)
          turn_log << log
          set_target(unit, log) if unit.target.null?
          move_unit(unit, log)
          attack(unit, log)
        end
        break if battle_ended?
      end
      process_outcome
    end

    def set_target(unit, log)
      return if unit.target.present? && unit.target.alive?
      all_enemies = @all_units - @team_assignments[unit.team]
      target = all_enemies.map do |enemy|
        [enemy, HexMap::Utils.distance(unit.tile, enemy.tile)]
      end.sort_by { |u| u[1] }.first
      
      unit.target = target

      log.log_target(target)
    end

    def move_unit(unit, log)
      # note: hueg pathfinding code
      
      # find max range -> min range tiles from target, max range has higher priority
      target = unit.target
      target_tiles = (unit.range_min..unit.range_max).map do |range|
        tile.landable_tiles_at_range(range)
      end.flatten
      
      # BFS to all target tiles
      #   store priority, distance from unit, and distance from target
      tile_infos = {
        unit.tile => {
          dist: 0, prev: nil,
          range: HexMap::Utils.distance(unit.tile, target.tile)
        }
      }
      queue = [unit.tile]
      visited = []

      until queue.empty? || (target_tiles - visited).empty?
        tile = queue.shift
        visited << tile
        tile.passable_neighbors.each do |n|
          unless visited.include? n
            queue << n
            tile_infos[n] = {
              prev: tile,
              dist: tile_infos[tile][:dist] + 1,
              range: HexMap::Utils.distance(n, target.tile)
            }
          end
        end
      end

      q = unit.tile.q
      r = unit.tile.r
      # if no path exists
      if (target_tiles - visited).count == target_tiles.count
      #   move towards tile closest to the target
      else 
        flattened_info = tile_infos.map do |k, v|
          { tile: k }.merge(v)
        end
        ideal_tiles = flattened_info.select do |info|
          target_tiles.include?(info[:tile]) && info[:dist] <= unit.move
        end
        # if within movement, 
        unless ideal_tiles.empty?
          #   move to closest tile that is as close to max range as possible
          good_tile = ideal_tiles.sort_by { |info| info[:range] }.reverse.first

          unless good_tile.nil?
            q = good_tile[:tile].q
            r = good_tile[:tile].r
          end
        else
          # if not, move towards tile closest to target
          closest = flattened_info.select do |info|
            info[:tile].empty_space && info[:dist] <= unit.move
          end.sort_by { |info| info[:range] }.first 

          unless closest.nil?
            q = closest[:tile].q
            r = closest[:tile].r
          end
        end
      end
      # add movement to battle log
      log.log_move(q, r)
    end

    def attack(unit, log)
      # check if hit
      #   apply damage
      #   add target as assist
      #   if dead
      #     move target from assist to kill
      # add attack to battle log
    end

    def battle_ended?
      # check if only one team survived
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

    def get_tile(x, y, z)
      get_tile(*HexMap::Utils.cube_to_offset(x, y, z))
    end
  end
end
