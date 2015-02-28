require 'rails_helper'

RSpec.describe Arena, :type => :model do
  it "can be saved with valid values" do
    arena = build(:arena)
    expect(arena).to be_valid
  end
  it "isn't valid if layout doesn't match rows * columns" do
    arena = build(:arena, rows: 1)
    expect(arena).to_not be_valid
  end
  it "isn't valid if layout contains non-standard character" do
    arena = build(:arena, layout: "A....D..X")
    expect(arena).to_not be_valid
  end
  it "isn't valid if layout has fewer teams than stated" do
    arena = build(:arena, layout: "........X")
    expect(arena).to_not be_valid
  end
  it "isn't valid if layout has more teams than stated" do
    arena = build(:arena, layout: ".AB.....X", players_max: 2)
    expect(arena).to_not be_valid
  end
  it "isn't valid if layout has more players than stated" do
    arena = build(:arena, layout: ".ABAB...X", team_count: 2, players_max: 3)
    expect(arena).to_not be_valid
  end

  context "activated" do
    it "isn't valid if there are missing bots" do
      arena = create(:arena, layout: "A......XX")
      arena.battle_bots = [ create(:battle_bot, arena: arena) ]
      arena.active = true
      expect(arena).to_not be_valid
    end
    it "isn't valid if there are an excess of bots" do
      arena = create(:arena, layout: "A.......X")
      arena.battle_bots = [ create(:battle_bot, arena: arena), create(:battle_bot, arena: arena) ]
      arena.active = true
      expect(arena).to_not be_valid
    end
    it "is valid if filler bots are present" do
      arena = create(:arena, layout: "AA......X", players_max: 2)
      arena.battle_bots = [ create(:battle_bot, arena: arena), 
                            create(:battle_bot, arena: arena, filler: true)]
      arena.active = true
      expect(arena).to be_valid
    end
    it "isn't valid if filler bots aren't present" do
      arena = create(:arena, layout: "AA......X", players_max: 2)
      arena.battle_bots = [ create(:battle_bot, arena: arena) ]
      arena.active = true
      expect(arena).to_not be_valid
    end
  end
end
