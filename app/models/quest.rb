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
      xp_win: 200,
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
      xp_win: 250,
      credits_win: 250,
      area_id: 2,
      unlocks: [ 26, 31 ]
    },
    {
      name: "Desert - 6",
      stage: 26,
      encounters: Encounter.generate_encounters([
        [1, :giant_scorpion, 4],
        [1, :salamander, 4],
        [2, :red_slime, 4],
        [2, :fire_scorpion, 4],
        [3, :magma_spider, 3]
      ]),
      xp_win: 300,
      credits_win: 300,
      area_id: 2,
      unlocks: [ 27 ]
    },
    {
      name: "Desert - 7",
      stage: 27,
      encounters: Encounter.generate_encounters([
        [1, :fire_scorpion, 4],
        [1, :salamander, 4],
        [2, :fire_scorpion, 3],
        [2, :magma_spider, 3]
      ]),
      xp_win: 350,
      credits_win: 350,
      area_id: 2,
      unlocks: [ 28 ]
    },
    {
      name: "Desert - 8",
      stage: 28,
      encounters: Encounter.generate_encounters([
        [1, :salamander, 6],
        [2, :fire_scorpion, 6],
        [3, :magma_spider, 4],
        [4, :cockatrice, 2]
      ]),
      xp_win: 300,
      credits_win: 300,
      area_id: 2,
      unlocks: [ 29 ]
    },
    {
      name: "Desert - 9",
      stage: 29,
      encounters: Encounter.generate_encounters([
        [1, :salamander, 2],
        [1, :fire_scorpion, 2],
        [2, :salamander, 3],
        [2, :fire_scorpion, 3],
        [3, :fire_scorpion, 3],
        [3, :magma_spider, 3],
        [4, :cockatrice, 4]
      ]),
      xp_win: 300,
      credits_win: 300,
      area_id: 2,
      unlocks: [ 30 ]
    },
    {
      name: "Desert - 10",
      stage: 30,
      encounters: Encounter.generate_encounters([
        [1, :giant_scorpion, 8],
        [2, :salamander, 8],
        [3, :fire_scorpion, 4],
        [3, :magma_spider, 4],
        [4, :red_slime, 6],
        [4, :cockatrice, 4],
        [5, :red_dragon, 1]
      ]),
      xp_win: 300,
      credits_win: 300,
      area_id: 2,
      unlocks: [ ]
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
      xp_win: 250,
      credits_win: 250,
      area_id: 3,
      unlocks: [ 32 ]
    },
    {
      name: "Haunted Castle - 2",
      stage: 32,
      encounters: Encounter.generate_encounters([
        [1, :giant_spider, 10],
        [2, :giant_spider, 7],
        [2, :skeleton, 5],
        [3, :skeleton, 6],
        [3, :evil_eye, 4]
      ]),
      xp_win: 300,
      credits_win: 300,
      area_id: 3,
      unlocks: [ 33 ]
    },
    {
      name: "Haunted Castle - 3",
      stage: 33,
      encounters: Encounter.generate_encounters([
        [1, :giant_spider, 6],
        [2, :skeleton, 6],
        [3, :evil_eye, 6],
        [4, :ghost, 4]
      ]),
      xp_win: 350,
      credits_win: 350,
      area_id: 3,
      unlocks: [ 34 ]
    },
    {
      name: "Haunted Castle - 4",
      stage: 34,
      encounters: Encounter.generate_encounters([
        [1, :skeleton, 4],
        [1, :evil_eye, 2],
        [2, :skeleton, 6],
        [2, :evil_eye, 2],
        [2, :ghost, 2],
        [3, :ghost, 3],
        [4, :revenant, 3]
      ]),
      xp_win: 400,
      credits_win: 400,
      area_id: 3,
      unlocks: [ 35 ]
    },
    {
      name: "Haunted Castle - 5",
      stage: 35,
      encounters: Encounter.generate_encounters([
        [1, :skeleton, 4],
        [1, :ghost, 2],
        [2, :skeleton, 2],
        [2, :ghost, 4],
        [3, :skeleton, 6],
        [3, :revenant, 2],
        [4, :ghost, 2],
        [4, :revenant, 2]
      ]),
      xp_win: 450,
      credits_win: 500,
      area_id: 3,
      unlocks: [ 36 ]
    },
    {
      name: "Haunted Castle - 6",
      stage: 36,
      encounters: Encounter.generate_encounters([
        [1, :ghost, 4],
        [1, :evil_eye, 2],
        [2, :revenant, 4],
        [2, :evil_eye, 2],
        [3, :wraith, 2]
      ]),
      xp_win: 500,
      credits_win: 700,
      area_id: 3,
      unlocks: [ 37 ]
    },
    {
      name: "Haunted Castle - 7",
      stage: 37,
      encounters: Encounter.generate_encounters([
        [1, :evil_eye, 2],
        [2, :evil_eye, 4],
        [3, :evil_eye, 6],
        [4, :evil_eye, 4],
        [4, :beholder, 2]
      ]),
      xp_win: 500,
      credits_win: 1000,
      area_id: 3,
      unlocks: [ 38 ]
    },
    {
      name: "Haunted Castle - 8",
      stage: 38,
      encounters: Encounter.generate_encounters([
        [1, :skeleton, 8],
        [1, :evil_eye, 2],
        [2, :ghost, 6],
        [2, :evil_eye, 3],
        [3, :revenant, 2],
        [3, :wraith, 2],
        [3, :beholder, 2]
      ]),
      xp_win: 750,
      credits_win: 2000,
      area_id: 3,
      unlocks: [ 39 ]
    },
    {
      name: "Haunted Castle - 9",
      stage: 39,
      encounters: Encounter.generate_encounters([
        [1, :green_slime, 6],
        [1, :giant_spider, 6],
        [2, :giant_spider, 6],
        [2, :skeleton, 3],
        [3, :skeleton, 6],
        [4, :evil_eye, 3]
      ]),
      xp_win: 750,
      credits_win: 4000,
      area_id: 3,
      unlocks: [ 40 ]
    },
    {
      name: "Haunted Castle - 10",
      stage: 40,
      encounters: Encounter.generate_encounters([
        [1, :blue_slime, 4],
        [2, :wraith, 3],
        [3, :beholder, 2],
        [4, :shadow_boss, 1]
      ]),
      xp_win: 1000,
      credits_win: 10000,
      area_id: 3,
      unlocks: [ ]
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
