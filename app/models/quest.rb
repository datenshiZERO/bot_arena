class Quest
  #has_many :encounters
  #has_many :raids

  attr_reader :name, :stage, :encounters, :xp_win, :credits_win, :area_id, :unlocks

  def id
    @stage
  end

  def unlocked_quests
    @unlocks.map { |id| Quest.find(id) }
  end

  def initialize(attr)
    @name = attr[:name]
    @stage = attr[:stage]
    @encounters = attr[:encounters]
    @xp_win = attr[:xp_win]
    @credits_win = attr[:credits_win]
    @unlocks = attr[:unlocks]
    @area_id = attr[:area_id]
  end

  QUEST_DATA = [
    {
      name: "Sewers - 1",
      stage: 1,
      encounters: Encounter.generate_encounters([
        [1, :green_slime, 1],
        [2, :green_slime, 1],
        [3, :green_slime, 2]
      ]),
      xp_win: 5,
      credits_win: 5,
      area_id: 0,
      unlocks: [ 2 ]
    },
    {
      name: "Sewers - 2",
      stage: 2,
      encounters: Encounter.generate_encounters([
        [1, :green_slime, 1],
        [2, :green_slime, 2],
        [3, :green_slime, 1],
        [3, :giant_rat, 1]
      ]),
      xp_win: 7,
      credits_win: 7,
      area_id: 0,
      unlocks: [ 3 ]
    },
    {
      name: "Sewers - 3",
      stage: 3,
      encounters: Encounter.generate_encounters([
        [1, :green_slime, 2],
        [2, :green_slime, 2],
        [2, :giant_rat, 1],
        [3, :green_slime, 4]
      ]),
      xp_win: 10,
      credits_win: 10,
      area_id: 0,
      unlocks: [ 4 ]
    },
    {
      name: "Sewers - 4",
      stage: 4,
      encounters: Encounter.generate_encounters([
        [1, :green_slime, 3],
        [2, :green_slime, 2],
        [2, :giant_rat, 2],
        [3, :giant_rat, 2],
        [3, :giant_spider, 2]
      ]),
      xp_win: 15,
      credits_win: 15,
      area_id: 0,
      unlocks: [ 5, 11 ]
    },
    {
      name: "Sewers - 5",
      stage: 5,
      encounters: Encounter.generate_encounters([
        [1, :green_slime, 2],
        [1, :giant_rat, 2],
        [2, :green_slime, 3],
        [2, :giant_rat, 2],
        [3, :green_slime, 2],
        [3, :giant_rat, 2],
        [3, :giant_spider, 2],
        [4, :red_slime, 2]
      ]),
      xp_win: 20,
      credits_win: 20,
      area_id: 0,
      unlocks: [ 6 ]
    },
    {
      name: "Sewers - 6",
      stage: 6,
      encounters: Encounter.generate_encounters([
        [1, :green_slime, 6],
        [1, :giant_rat, 2],
        [2, :giant_spider, 3],
        [2, :giant_rat, 2],
        [3, :green_slime, 4],
        [3, :giant_spider, 4]
      ]),
      xp_win: 25,
      credits_win: 25,
      area_id: 0,
      unlocks: [ 7 ]
    },
    {
      name: "Sewers - 7",
      stage: 7,
      encounters: Encounter.generate_encounters([
        [1, :giant_rat, 1],
        [1, :giant_spider, 1],
        [1, :red_slime, 2],
        [2, :giant_spider, 3],
        [2, :red_slime, 2],
        [3, :dire_spider, 1]
      ]),
      xp_win: 35,
      credits_win: 35,
      area_id: 0,
      unlocks: [ 8 ]
    },
    {
      name: "Sewers - 8",
      stage: 8,
      encounters: Encounter.generate_encounters([
        [1, :giant_rat, 4],
        [1, :red_slime, 2],
        [2, :giant_spider, 3],
        [2, :red_slime, 2],
        [3, :red_slime, 2],
        [3, :dire_spider, 2]
      ]),
      xp_win: 50,
      credits_win: 50,
      area_id: 0,
      unlocks: [ 9 ]
    },
    {
      name: "Sewers - 9",
      stage: 9,
      encounters: Encounter.generate_encounters([
        [1, :giant_spider, 8],
        [2, :giant_spider, 3],
        [2, :red_slime, 2],
        [3, :red_slime, 4],
        [4, :red_slime, 2],
        [4, :dire_spider, 2],
        [5, :dire_spider, 3]
      ]),
      xp_win: 75,
      credits_win: 75,
      area_id: 0,
      unlocks: [ 10 ]
    },
    {
      name: "Sewers - 10",
      stage: 10,
      encounters: Encounter.generate_encounters([
        [1, :green_slime, 12],
        [2, :red_slime, 6],
        [3, :blue_slime, 3]
      ]),
      xp_win: 200,
      credits_win: 200,
      area_id: 0,
      unlocks: [ ]
    },
    {
      name: "Forest - 1",
      stage: 11,
      encounters: Encounter.generate_encounters([
        [1, :rabid_rabbit, 1],
        [2, :rabid_rabbit, 2],
        [3, :rabid_rabbit, 4],
        [4, :rabid_rabbit, 8]
      ]),
      xp_win: 20,
      credits_win: 20,
      area_id: 1,
      unlocks: [ 12 ]
    },
    {
      name: "Forest - 2",
      stage: 12,
      encounters: Encounter.generate_encounters([
        [1, :rabid_rabbit, 3],
        [2, :giant_snake, 3],
        [3, :rabid_rabbit, 5],
        [4, :giant_snake, 4]
      ]),
      xp_win: 30,
      credits_win: 30,
      area_id: 1,
      unlocks: [ 13 ]
    },
    {
      name: "Forest - 3",
      stage: 13,
      encounters: Encounter.generate_encounters([
        [1, :rabid_rabbit, 4],
        [2, :giant_snake, 2],
        [2, :wolf, 1],
        [3, :giant_snake, 3],
        [3, :wolf, 2]
      ]),
      xp_win: 35,
      credits_win: 35,
      area_id: 1,
      unlocks: [ 14 ]
    },
    {
      name: "Forest - 4",
      stage: 14,
      encounters: Encounter.generate_encounters([
        [1, :giant_snake, 4],
        [2, :giant_snake, 3],
        [2, :wolf, 2],
        [3, :wolf, 2],
        [3, :goblin_warrior, 2]
      ]),
      xp_win: 50,
      credits_win: 50,
      area_id: 1,
      unlocks: [ 15 ]
    },
    {
      name: "Forest - 5",
      stage: 15,
      encounters: Encounter.generate_encounters([
        [1, :wolf, 4],
        [2, :wolf, 3],
        [2, :goblin_warrior, 2],
        [3, :goblin_warrior, 2],
        [3, :alpha_wolf, 2]
      ]),
      xp_win: 60,
      credits_win: 60,
      area_id: 1,
      unlocks: [ 16, 21 ]
    },
    {
      name: "Forest - 6",
      stage: 16,
      encounters: Encounter.generate_encounters([
        [1, :wolf, 4],
        [1, :goblin_warrior, 2],
        [2, :goblin_warrior, 4],
        [2, :alpha_wolf, 2],
        [3, :rabid_rabbit, 4],
        [3, :alpha_wolf, 4]
      ]),
      xp_win: 75,
      credits_win: 75,
      area_id: 1,
      unlocks: [ 17 ]
    },
    {
      name: "Forest - 7",
      stage: 17,
      encounters: Encounter.generate_encounters([
        [1, :giant_snake, 8],
        [1, :goblin_warrior, 2],
        [2, :wolf, 6],
        [2, :alpha_wolf, 2],
        [3, :goblin_warrior, 4],
        [3, :alpha_wolf, 2],
        [4, :goblin_berserker, 2]
      ]),
      xp_win: 100,
      credits_win: 100,
      area_id: 1,
      unlocks: [ 18 ]
    },
    {
      name: "Forest - 8",
      stage: 18,
      encounters: Encounter.generate_encounters([
        [1, :alpha_wolf, 4],
        [2, :goblin_berserker, 2],
        [3, :alpha_wolf, 5],
        [4, :goblin_berserker, 2]
      ]),
      xp_win: 150,
      credits_win: 150,
      area_id: 1,
      unlocks: [ 19 ]
    },
    {
      name: "Forest - 9",
      stage: 19,
      encounters: Encounter.generate_encounters([
        [1, :giant_snake, 5],
        [1, :goblin_warrior, 5],
        [2, :wolf, 8],
        [2, :alpha_wolf, 3],
        [3, :goblin_warrior, 5],
        [3, :alpha_wolf, 2],
        [4, :goblin_berserker, 3]
      ]),
      xp_win: 200,
      credits_win: 200,
      area_id: 1,
      unlocks: [ 20 ]
    },
    {
      name: "Forest - 10",
      stage: 20,
      encounters: Encounter.generate_encounters([
        [1, :goblin_warrior, 4],
        [2, :alpha_wolf, 4],
        [3, :goblin_berserker, 4],
        [4, :green_dragon, 1]
      ]),
      xp_win: 500,
      credits_win: 500,
      area_id: 1,
      unlocks: [ ]
    },
    {
      name: "Desert - 1",
      stage: 21,
      encounters: Encounter.generate_encounters([
        [1, :giant_scorpion, 5],
        [2, :giant_scorpion, 5],
        [3, :giant_scorpion, 5],
        [3, :red_slime, 3]
      ]),
      xp_win: 50,
      credits_win: 50,
      area_id: 2,
      unlocks: [ 22 ]
    },
    {
      name: "Desert - 2",
      stage: 22,
      encounters: Encounter.generate_encounters([
        [1, :red_slime, 3],
        [2, :giant_scorpion, 3],
        [3, :red_slime, 6],
        [4, :giant_scorpion, 6],
        [5, :red_slime, 9],
        [6, :giant_scorpion, 9],
        [7, :salamander, 3]
      ]),
      xp_win: 75,
      credits_win: 75,
      area_id: 2,
      unlocks: [ 23 ]
    },
    {
      name: "Desert - 3",
      stage: 23,
      encounters: Encounter.generate_encounters([
        [1, :red_slime, 10],
        [2, :giant_scorpion, 10],
        [3, :red_slime, 10],
        [4, :giant_scorpion, 10],
        [5, :salamander, 5]
      ]),
      xp_win: 150,
      credits_win: 150,
      area_id: 2,
      unlocks: [ 24 ]
    },
    {
      name: "Desert - 4",
      stage: 24,
      encounters: Encounter.generate_encounters([
        [1, :red_slime, 6],
        [1, :giant_scorpion, 6],
        [2, :red_slime, 6],
        [2, :giant_scorpion, 6],
        [3, :salamander, 6],
        [4, :red_slime, 6],
        [4, :giant_scorpion, 6],
        [5, :fire_scorpion, 3]
      ]),
      xp_win: 300,
      credits_win: 300,
      area_id: 2,
      unlocks: [ 25 ]
    },
    {
      name: "Desert - 5",
      stage: 25,
      encounters: Encounter.generate_encounters([
        [1, :red_slime, 6],
        [1, :giant_scorpion, 6],
        [2, :red_slime, 6],
        [2, :salamander, 3],
        [3, :red_slime, 6],
        [3, :fire_scorpion, 3],
        [4, :red_slime, 4],
        [4, :magma_spider, 2]
      ]),
      xp_win: 500,
      credits_win: 500,
      area_id: 2,
      unlocks: [ 26, 31 ]
    },
    {
      name: "Desert - 6",
      stage: 26,
      encounters: Encounter.generate_encounters([
        [1, :red_slime, 6],
        [1, :giant_scorpion, 6],
        [2, :red_slime, 6],
        [2, :salamander, 3],
        [3, :red_slime, 6],
        [3, :fire_scorpion, 3],
        [4, :red_slime, 4],
        [4, :magma_spider, 2]
      ]),
      xp_win: 500,
      credits_win: 500,
      area_id: 2,
      unlocks: [ 27 ]
    },
    {
      name: "Haunted Castle - 1",
      stage: 31,
      encounters: Encounter.generate_encounters([
        [1, :green_slime, 6],
        [1, :giant_spider, 6],
        [2, :giant_spider, 6],
        [2, :skeleton, 3],
        [3, :skeleton, 6],
        [4, :evil_eye, 3]
      ]),
      xp_win: 300,
      credits_win: 300,
      area_id: 3,
      unlocks: [ 32 ]
    }
  ]

  QUESTS = QUEST_DATA.map { |q| Quest.new(q) }

  def self.area(area_id)
    QUESTS.select { |q| q.area_id == area_id }
  end

  def self.find(id)
    QUESTS.select { |q| q.stage == id.to_i }.first
  end
end
