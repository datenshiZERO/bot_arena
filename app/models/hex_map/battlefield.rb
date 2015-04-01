module HexMap
  class Battlefield
    def initialize(arena, units)
      @arena = arena
      setup_units(units)
      setup_bots
      setup_map
    end

    def setup_units(units)
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
      end.map { |u| HexMap::Unit.new(u) }.shuffle
    end

    def setup_map
      @map = []
      @spawn_points = {}
      @team_assignments = {}
      unit_idx = 0
      bot_idx = 0
      @arena.columns.times do |q|
        column = []
        @arena.rows.times do |r|
          value = @arena.processed_layout[r][q]
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
          column << tile
        end
        @map << column
      end

      @all_units = (@units + @bots).shuffle
      @all_units.each_with_index do |unit, i|
        unit.id = i
      end
    end

    def process_battle
      # set to 0 to see full log
      Rails.logger.level = 1

      @battle_log = []
      @turns = 1
      while @turns <= @arena.turn_limit
        turn_log = []
        @battle_log << turn_log
        @all_units.select { |u| u.alive? }.each do |unit|
          next if unit.dead? # units can die earlier in the turn
          log = HexMap::UnitTurnLog.new(unit)
          set_target(unit, log)
          move_unit(unit, log)
          attack(unit, log)
          turn_log << log.to_hash
          break if battle_ended?
        end
        break if battle_ended?
        @turns += 1
      end
      #Battle.transaction do
        process_outcome
      #end
    end

    def set_target(unit, log)
      unit.target = nil if unit.target.present? && unit.target.dead?
      return if unit.target.present? 
      all_enemies = @all_units - @team_assignments[unit.team]
      targets = all_enemies.select { |t| t.alive? }.map do |enemy|
        [enemy, HexMap::Utils.distance(unit.tile, enemy.tile)]
      end.sort_by { |u| u[1] }
      return if targets.empty?
      
      target = targets.first[0]
      
      unit.target = target

      log.log_target(target)
    end

    def move_unit(unit, log)

      Rails.logger.debug "turn #{@turns} unit #{unit.id} - #{unit.tile.q}, #{unit.tile.r}"

      # note: hueg pathfinding code
      
      # find max range -> min range tiles from target, max range has higher priority
      target = unit.target
      Rails.logger.debug "t #{target.name} at #{target.tile.q} #{target.tile.r}"
      target_tiles = (unit.range_min..unit.range_max).map do |range|
        target.tile.landable_tiles_at_range(range, unit)
      end.flatten

      target_tiles.each { |t| Rails.logger.debug "tt - #{t.q} #{t.r}" }
      
      # BFS to all target tiles
      #   store priority, distance from unit, and distance from target
      dist = { unit.tile => 0 }
      prev = {}
      range = { unit.tile => HexMap::Utils.distance(unit.tile, target.tile) }
      queue = [unit.tile]
      visited = []

      # target_tiles is checked only if there are target_tiles
      until queue.empty? || (target_tiles.count > 0 && (target_tiles - visited).empty?)
        tile = queue.shift
        visited << tile
        tile.passable_neighbors(unit).each do |n|
          Rails.logger.debug "cur #{tile.q} #{tile.r} neighbor #{n.q} #{n.r} vis? #{visited.include? n}"
          unless visited.include? n
            queue << n
            if prev[n].nil?
              prev[n] = tile
              dist[n] = dist[tile] + 1
              range[n] = HexMap::Utils.distance(n, target.tile)
            end
          end
        end
      end

      moves = [[unit.tile.q, unit.tile.r]]

      flattened_info = visited.map() do |t|
        { 
          tile: t,
          prev: prev[t],
          dist: dist[t],
          range: range[t]
        } 
      end

      # if no path exists
      if (target_tiles - visited).count == target_tiles.count
        Rails.logger.debug "#{visited.count} no path"

        flattened_info.select do |info|
          (info[:tile] == unit.tile || info[:tile].empty_space?)
        end.each do |info|
          Rails.logger.debug "#{info[:tile].q},#{info[:tile].r} #{info[:dist]} #{info[:range]}"
        end

        # move towards tile closest to the target
        closest = flattened_info.select do |info|
          (info[:tile] == unit.tile || info[:tile].empty_space?)
        end.sort_by { |info| info[:range] }.first

        unless closest == unit.tile || closest.nil?
          Rails.logger.debug "#{closest[:tile].q},#{closest[:tile].r}"
          Rails.logger.debug "id: #{closest[:tile].unit.nil? ? "n/a" : closest[:tile].unit.id}"

          closest_tile = closest[:tile]

          # if not within movement, backtrack to the tile which is within movement
          # stop when current tile is current tile
          while closest_tile != unit.tile && (dist[closest_tile] > unit.move || !closest_tile.empty_space?)
            closest_tile = prev[closest_tile]
          end

          current = closest_tile
          next_moves = []
          while current != unit.tile
            next_moves << [current.q, current.r]
            current = prev[current]
          end
          moves = moves + next_moves.reverse
          # move to target
          unit.move_to(closest_tile)
        end
      else 
        Rails.logger.debug "with path"

        ideal_tiles = flattened_info.select do |info|
          target_tiles.include?(info[:tile])
        end

        # move to closest tile that is as close to max range as possible
        # pick the final target tile by finding the max range and min distance
        target_tile = ideal_tiles.sort_by { |t| [-t[:range], t[:dist]] }.first[:tile]

        ideal_tiles.sort_by { |t| [-t[:range], t[:dist]] }.each do |t|
          Rails.logger.debug "s #{t[:tile].q}, #{t[:tile].r} e #{t[:tile].empty_space?} r #{t[:range]} d #{t[:dist]}"
        end

        Rails.logger.debug "t #{target_tile.q} #{target_tile.r}"
        dist.keys.map { |x| "#{x.q}, #{x.r} - r #{range[x]} d #{dist[x]} " }.each { |x| Rails.logger.debug x }
        Rails.logger.debug dist[target_tile]

        # if not within movement, backtrack to the tile which is within movement
        # stop when current tile is current tile
        while target_tile != unit.tile && (dist[target_tile] > unit.move || !target_tile.empty_space?)
          target_tile = prev[target_tile]
        end

        current = target_tile
        Rails.logger.debug "l #{moves}"
        next_moves = []
        while current != unit.tile
          next_moves << [current.q, current.r]
          current = prev[current]
        end
        Rails.logger.debug "n #{next_moves}"
        moves = moves + next_moves.reverse

        # move to target
        unit.move_to(target_tile)
      end
      #Rails.logger.debug moves.last
      # add movement to battle log
      log.log_moves(moves)
    end

    def attack(unit, log)
      target_distance = HexMap::Utils.distance(unit.tile, unit.target.tile)
      
      Rails.logger.debug "#{unit.tile.q},#{unit.tile.r} - #{unit.target.tile.q},#{unit.target.tile.r} #{target_distance}"

      unless (unit.range_min..unit.range_max).include? target_distance
        # if out of range, check if there is a new target within range then set as new target
        all_enemies = @all_units - @team_assignments[unit.team]
        new_targets = all_enemies.select { |t| t.alive? }.map do |enemy|
          [enemy, HexMap::Utils.distance(unit.tile, enemy.tile)]
        end.select do |u| 
          (unit.range_min..unit.range_max).include? u[1] 
        end.sort_by { |u| u[1] }

        new_targets.each do |n|
          Rails.logger.debug "nt #{n[0].id} - d #{n[1]}"
        end

        # if there isn't, cancel attack
        return if new_targets.empty?

        # set farthest target within range as new target
        unit.target = new_targets.last[0]
        log.log_new_target(unit.target)
      end

      chance = unit.accuracy - unit.target.evade

      roll = Random.rand(20) + 1

      # check if hit
      hit = false
      damage = nil
      kill = false
      if roll == 20 || (roll >= chance && roll != 1)
        hit = true
        damage = unit.damage - unit.target.defense
        damage = 1 if damage < 1
        unit.target.hp = unit.target.hp - damage
        #   apply damage
        #   add target as assist
        unless unit.assists.include? unit.target
          unit.assists << unit.target
        end

        #   if dead
        if unit.target.hp < 1
          # move target from assist to kill
          unit.assists.delete unit.target
          unit.kills << unit.target
          kill = true
          unit.target.tile.unit = nil
          unit.target.tile = nil
        end
      end
      # add attack to battle log
      log.log_attack(hit, damage, kill)
    end

    def battle_ended?
      # check if only one team survived
      remaining_teams.count <= 1
    end

    def remaining_teams
      @all_units.select { |u| u.alive? }
        .group_by { |u| u.team }
    end

    def process_outcome
      # summarize everything in battle log

      battle = Battle.new(arena: @arena)

      winning_team = nil
      # bots win, team win, draw TODO survived
      if remaining_teams.count == 1
        winning_team = remaining_teams.first[0]
        if winning_team == "X"
          battle.outcome = "Bots Win"
        else
          battle.outcome = "Team #{winning_team} Wins"
        end
      else
        battle.outcome = "Draw"
      end
      battle.winning_team = winning_team

      outcomes = @units.reject { |u| u.bot }.map do |unit|
        #   remove non-killed units from assist
        unit.assists.reject! { |t| t.alive? }
        #   create unit battle outcome
        outcome = UnitBattleOutcome.new(unit_id: unit.real_id)
        outcome.team = unit.team
        outcome.outcome = (unit.alive? ? "survived" : "killed")
        outcome.kills = unit.kills.count
        outcome.assists = unit.assists.count
        outcome.xp = 
          @arena.xp_join +
          @arena.xp_kill * (outcome.kills + outcome.assists / 5) +
          (unit.alive? ? @arena.xp_survive : 0) +
          (unit.team == winning_team ? @arena.xp_win : 0)
        outcome.credits = 
          @arena.credits_kill * outcome.kills +
          (unit.alive? ? @arena.credits_survive : 0) +
          (unit.team == winning_team ? @arena.credits_win : 0)
        outcome.details = JSON.generate(unit.details)
        outcome
      end

      battle.battle_log = JSON.generate({ 
        participants: @all_units.inject({}) do |p, unit| 
          p[unit.id] = unit.details
          p
        end,
        battle_log: @battle_log
      })
      battle.unit_battle_outcomes = outcomes
      battle.save

      # update xp/kills
      outcomes.group_by { |outcome| outcome.unit.user }.each do |user, user_outcomes|
        user.with_lock do
          user_outcomes.each do |outcome|
            user.total_missions += 1
            user.total_kills += outcome.kills
            user.total_xp += outcome.xp
            user.credits += outcome.credits
          end
          user.save!
        end
      end

    end

    def get_tile(q, r)
      #puts "-- #{q} #{r}"
      return nil if (q < 0 || r < 0 || q >= @arena.columns || r >= @arena.rows)

      @map[q][r]
    end

    def get_3d_tile(x, y, z)
      #puts "*- #{x} #{y} #{z}"
      get_tile(*HexMap::Utils.cube_to_offset(x, y, z))
    end
  end
end
