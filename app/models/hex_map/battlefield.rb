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
            tile.unit.spawn_point = tile
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

      moves = [[unit.tile.q, unit.tile.r]]

      flattened_info = tile_infos.map do |k, v|
        { tile: k }.merge(v)
      end

      # if no path exists
      if (target_tiles - visited).count == target_tiles.count
        # move towards tile closest to the target
        closest = flattened_info.select do |info|
          info[:tile].empty_space && info[:dist] <= unit.move
        end.sort_by { |info| info[:range] }.first 

        unless closest.nil?
          # move to target
          unit.move_to(closest)

          current = closest
          next_moves = []
          while current[:tile] != unit.tile
            next_moves << [current[:tile].q, current[:tile].r]
            current = closest[:prev]
          end
          moves = moves + next_moves.reverse
        end
      else 
        ideal_tiles = flattened_info.select do |info|
          target_tiles.include?(info[:tile])
        end
        # move to closest tile that is as close to max range as possible
        # pick the final target tile by finding the max range and min distance
        target_tile = ideal_tiles.sort do |a, b| 
          if a[:range] == b[:range]
            a[:dist] <=> b[:dist]
          else
            b[:range] <=> a[:range]
          end
        end.first

        # if not within movement, backtrack to the tile which is within movement
        while target_tile[:dist] > unit.move
          target_tile = target_tile[:prev]
        end

        # move to target
        unit.move_to(target_tile)

        current = target_tile
        next_moves = []
        while current[:tile] != unit.tile
          next_moves << [current[:tile].q, current[:tile].r]
          current = closest[:prev]
        end
        moves = moves + next_moves.reverse
      end
      # add movement to battle log
      log.log_moves(moves)
    end

    def attack(unit, log)
      # TODO if out of range, check if there is a new target within range
      #   set as new target
      
      target_distance = HexMap::Utils.distance(unit.tile, unit.target.tile)
      return unless (unit.range_min..unit.range_max).include? target_distance 

      chance = unit.accuracy - unit.target.evade

      roll = Random.rand(20) + 1

      # check if hit
      hit = false
      damage = nil
      kill = false
      if roll == 20 || (roll >= chance && roll != 1)
        damage = unit.damage - unit.target.defense
        damage = 1 if damage < 1
        unit.target.hp = unit.target.hp - damage
        #   apply damage
        #   add target as assist
        unless unit.assists.include? target
          unit.assists << target
        end

        #   if dead
        if unit.target.hp < 1
          # move target from assist to kill
          unit.assists.delete target
          unit.kills << target
          kill = true
        end
      end
      # add attack to battle log
      log.log_attack(hit, damage, kill)
    end

    def battle_ended?
      # check if only one team survived
      @all_units.select { |u| u.alive }
        .group_by { |u| u.team }
        .count <= 1
    end

    def process_outcome

      outcomes = []
      @units.each do |unit|
        #   remove non-killed units from assist
        unit.assists.reject! { |t| t.alive? }
        #   create unit battle outcome
        outcome = UnitBattleOutcome.new(unit: unit)
        outcome.outcome = (unit.alive? ? "survived" : "killed")
        outcome.kills = unit.kills.count
        outcome.assists = unit.assists.count
        #TODO unit snapshot in details
      end

      # summarize everything in battle log
      
      battle = Battle.new(arena: @arena)
      battle.outcome = "..."
      battle.battle_log = JSON.generate(@battle_log)
      battle.unit_battle_outcomes = outcomes
      battle.save

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
