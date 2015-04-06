class Quest
  #has_many :encounters
  #has_many :raids

  attr_reader :name, :stage, :encounters, :xp_win, :credits_win, :area_id, :unlocks

  def id
    @stage
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
      name: "Forest - 1",
      stage: 11,
      encounters: Encounter.generate_encounters([
        [1, :rabid_rabbit, 1],
        [2, :rabid_rabbit, 2],
        [3, :rabid_rabbit, 4],
        [4, :rabid_rabbit, 6]
      ]),
      xp_win: 20,
      credits_win: 20,
      area_id: 1,
      unlocks: [ 12 ]
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
