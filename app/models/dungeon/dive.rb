module Dungeon
  class Dive
    def initialize(raid)
      # todo validate raid
      @raid = raid
      @raid_log = [] #2d
      @quest = raid.quest
      @kills = 0
      @xp = 0
      @credits = 0
      setup_party
      setup_monsters
    end 

    def setup_party
      # clear out empty slots
      @party = [
        [ @raid.unit_1_id, @raid.unit_1_front ],
        [ @raid.unit_2_id, @raid.unit_2_front ],
        [ @raid.unit_3_id, @raid.unit_3_front ],
        [ @raid.unit_4_id, @raid.unit_4_front ],
        [ @raid.unit_5_id, @raid.unit_5_front ],
        [ @raid.unit_6_id, @raid.unit_6_front ]
      ].reject { |u| u[0].nil? }
      .map { |u| Dungeon::Unit.new(*u) }

      @party.each_with_index do |unit, idx|
        unit.id = idx
      end
      @initial_party = @party.map { |u| u.details }
    end

    def setup_monsters
      # convert to hash of arrays representing waves
      @monster_waves = @quest.encounters.sort_by { |e| e.wave }
      .group_by { |e| e.wave }
      .inject({}) do |hash, (wave_no, encounters)|
        wave = []
        encounters.each do |encounter|
          encounter.count.times do
            wave << Dungeon::Unit.new(encounter.monster_slug)
          end
        end
        # each monster contains its index in the wave
        wave.each_with_index do |monster, idx|
          monster.id = idx
        end
        hash[wave_no] = wave
        hash
      end

      @initial_monsters = @monster_waves.inject({}) do |hash, (wave_no, wave)|
        hash[wave_no] = wave.map { |m| m.details }
        hash
      end
    end

    def process_raid
      @battle_log = []
      @monster_waves.each do |current_wave, wave|
        @current_log = []
        @battle_log << @current_log
        move_surviving_forward
        process_wave(current_wave, wave)
        break if party_wiped?
      end
      process_outcome
    end

    def process_wave(current_wave, wave)
      # single shuffle?
      current_brawl = (@party + wave).shuffle.sort_by { |a| -a.move }
      while true
        current_brawl.each do |actor|
          # skip if dead
          next if actor.dead?

          # set target
          # attack
          # end wave if all units in one side is dead
          if actor.monster
            target = monster_target(actor)
            attack_unit(actor, target)
          else
            # skip if damage 0
            next if actor.damage == 0
            target = unit_target(actor, current_wave)
            attack_monster(actor, target)
          end
          break if monsters_wiped?(current_wave) || party_wiped?
        end
        break if monsters_wiped?(current_wave) || party_wiped?
      end
    end 

    def unit_target(unit, current_wave)
      # find highest damage, lowest health
      @monster_waves[current_wave].select { |m| m.alive? }.max do |a, b|
        (a.damage.to_f / a.hp) <=> (b.damage.to_f / b.hp)
      end
    end

    def monster_target(monster)
      # randomize living lol
      @party.select { |u| u.alive? }.sample
    end

    def attack_unit(monster, unit)
      action_log = { 
        action: "attack",
        monster: true,
        id: monster.id,
        target: unit.id
      }
      eff_accuracy = monster.accuracy
      eff_damage = monster.damage
      if !unit.front && !monster.ranged
        # modify damage/accuracy if unit in back row and attacker isn't ranged
        eff_accuracy = eff_accuracy * 2 / 3
        eff_damage = eff_damage / 2
      end

      # roll, check if hit
      if target_hit?(eff_accuracy, unit.evade)
        # process damage
        eff_damage -= unit.defense
        eff_damage = 1 if eff_damage < 1
        unit.hp -= eff_damage

        action_log[:damage] = eff_damage
        action_log[:hit] = true
      else
        action_log[:hit] = false
      end
      @current_log << action_log
      
      # if target is killed, move surviving forward
      move_surviving_forward if unit.dead?
    end

    def attack_monster(unit, monster)
      action_log = { 
        action: "attack",
        monster: false,
        id: unit.id,
        target: monster.id
      }
      eff_accuracy = unit.accuracy
      eff_damage = unit.damage
      if !unit.front && !unit.ranged
        # modify damage/accuracy if unit in back row and isn't ranged
        eff_accuracy = eff_accuracy * 2 / 3
        eff_damage = eff_damage / 2
      end

      # roll, check if hit
      if target_hit?(eff_accuracy, monster.evade)
        # process damage
        eff_damage -= monster.defense
        eff_damage = 1 if eff_damage < 1
        monster.hp -= eff_damage
        action_log[:damage] = eff_damage
        action_log[:hit] = true
      else
        action_log[:hit] = false
      end
      @current_log << action_log

      if monster.dead?
        @kills += 1
        @xp += monster.template.xp
        @credits += monster.template.credits
      end
    end

    def target_hit?(accuracy, evade)
      roll = Random.rand(20) + 1
      return true if roll == 20
      return false if roll == 1
      return true if roll >= (accuracy - evade)
      false
    end

    def move_surviving_forward
      return if party_wiped?
      if @party.select { |u| u.front && u.alive? }.empty?
        @party.select { |u| u.alive? }.each { |u| u.front = true }
        action_log = { 
          action: "move forward"
        }
        @current_log << action_log
      end
    end

    def monsters_wiped?(current_wave)
      @monster_waves[current_wave].count { |m| m.alive? } == 0
    end

    def party_wiped?
      @party.count { |u| u.alive? } == 0
    end

    def process_outcome
      if party_wiped?
        @raid.outcome = "Failed"
      else
        @raid.outcome = "Success"
        @xp += @quest.xp_win
        @credits += @quest.credits_win
      end

      user = @raid.user
      user.with_lock do
        user.total_xp += @xp
        user.total_missions += 1
        user.total_kills += @kills
        user.credits += @credits
        if !party_wiped?
          user.unlock_quests(@quest)
          user.complete_quest(@quest)
        end
        user.save!
      end
      if user.completed_all_quests? && user.speedrun_end_at.nil?
        speedrun_end = DateTime.now
        speedrun_start = user.speedrun_start_at || user.created_at
        speedrun_time = (speedrun_end.to_time - speedrun_start.to_time).to_i
        raid_count = user.raids.where("created_at >= ?", speedrun_start).count

        user.with_lock do 
          user.speedrun_end_at = speedrun_end
          user.speedrun_time = speedrun_time
          user.speedrun_raid_count = raid_count
          if user.best_speedrun_time.nil? || speedrun_time < user.best_speedrun_time
            user.best_speedrun_time = speedrun_time
            user.best_speedrun_at = speedrun_end
            user.best_speedrun_raid_count = raid_count
          end
          if user.efficient_speedrun_raid_count.nil? || raid_count < user.efficient_speedrun_raid_count
            user.efficient_speedrun_time = speedrun_time
            user.efficient_speedrun_at = speedrun_end
            user.efficient_speedrun_raid_count = raid_count
          end
          user.save!
        end
      end
      @raid.xp = @xp
      @raid.credits = @credits
      @raid.kills = @kills
      # TODO
      @raid.raid_log = JSON.generate({
        area: @quest.area[:display_class],
        party: @initial_party,
        monsters: @initial_monsters,
        raid_log: @battle_log
      })

      @raid.save
    end
  end
end
