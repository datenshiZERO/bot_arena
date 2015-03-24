class Monster
  attr_reader :name, :slug, :hp, :move, :evade, :defense, :damage, :accuracy, 
    :ranged, :xp, :credits

  def initialize(name:, slug:, hp: 4, move: 1, evade: 6, defense: 0, damage: 1, 
                 accuracy: 6, ranged: false, xp: 4, credits: 2)
    @name = name
    @slug = slug
    @hp = hp
    @move = move
    @evade = evade
    @defense = defense
    @damage = damage
    @accuracy = accuracy
    @ranged = ranged
    @xp = xp
    @credits = credits
  end

  def icon_class
    @slug.gsub("_", "-")
  end

  ALL_MONSTERS = [
    self.new(
      name: "Green Slime",
      slug: "green_slime"
    ),
    self.new(
      name: "Rabid Rabbit",
      slug: "rabid_rabbit",
      hp:  6, move: 1, evade:  7, damage: 1, accuracy:  7, xp:  7, credits:  3
    ),
    self.new(
      name: "Giant Rat",
      slug: "giant_rat",
      hp:  5, move: 1, evade:  8, damage: 2, accuracy:  8, xp:  8, credits:  4
    ),
    self.new(
      name: "Giant Spider",
      slug: "giant_spider",
      hp: 15, move: 2, evade:  9, damage: 3, accuracy:  9, xp: 15, credits: 10
    ),
    self.new(
      name: "Giant Scorpion",
      slug: "giant_scorpion",
      hp: 15, move: 3, evade: 12, damage: 3, accuracy: 10, xp: 15, credits: 15
    ),
    self.new(
      name: "Giant Snake",
      slug: "giant_snake",
      hp: 17, move: 2, evade: 10, damage: 2, accuracy: 10, xp: 15, credits: 10
    ),
    self.new(
      name: "Red Slime",
      slug: "red_slime",
      hp: 20, move: 2, evade: 10, damage: 4, accuracy: 10, xp: 20, credits: 15
    ),
    self.new(
      name: "Dire Spider",
      slug: "dire_spider",
      hp: 30, move: 3, evade: 15, defense: 1, damage: 5, accuracy: 13, xp: 30, credits: 30
    ),
    self.new(
      name: "Goblin Warrior",
      slug: "goblin_warrior",
      hp: 30, move: 2, evade: 16, defense: 2, damage: 4, accuracy: 13, xp: 30, credits: 30
    ),
    self.new(
      name: "Skeleton",
      slug: "skeleton",
      hp: 35, move: 2, evade: 14, defense: 1, damage: 5, accuracy: 13, xp: 35, credits: 35
    ),
    self.new(
      name: "Salamander",
      slug: "salamander",
      hp: 40, move: 3, evade: 16, defense: 2, damage: 7, accuracy: 14, xp: 40, credits: 40
    ),
    self.new(
      name: "Alpha Wolf",
      slug: "alpha_wolf",
      hp: 45, move: 3, evade: 17, defense: 2, damage: 8, accuracy: 14, xp: 45, credits: 45
    ),
    self.new(
      name: "Evil Eye",
      slug: "evil_eye",
      hp: 50, move: 3, evade: 17, defense: 2, damage: 10, accuracy: 10, xp: 50, credits: 50, ranged: true
    ),
    self.new(
      name: "Fire Scorpion",
      slug: "fire_scorpion",
      hp: 50, move: 4, evade: 18, defense: 2, damage:  8, accuracy: 14, xp: 50, credits: 50
    ),
    self.new(
      name: "Ghost",
      slug: "ghost",
      hp: 60, move: 3, evade: 22, defense: 3, damage: 10, accuracy: 15, xp: 60, credits: 60
    ),
    self.new(
      name: "Goblin Berserker",
      slug: "goblin_berserker",
      hp: 70, move: 5, evade: 18, defense: 2, damage: 14, accuracy: 14, xp: 70, credits: 70
    ),
    self.new(
      name: "Magma Spider",
      slug: "magma_spider",
      hp: 70, move: 4, evade: 20, defense: 3, damage: 12, accuracy: 15, xp: 70, credits: 70
    ),
    self.new(
      name: "Revenant",
      slug: "revenant",
      hp: 80, move: 4, evade: 19, defense: 3, damage: 13, accuracy: 15, xp: 80, credits: 80
    ),
    self.new(
      name: "Cockatrice",
      slug: "cockatrice",
      hp: 90, move: 5, evade: 20, defense: 3, damage: 15, accuracy: 16, xp: 90, credits: 90
    ),
    self.new(
      name: "Wraith",
      slug: "wraith",
      hp: 90, move: 4, evade: 22, defense: 4, damage: 14, accuracy: 16, xp: 90, credits: 90
    ),
    self.new(
      name: "Beholder",
      slug: "beholder",
      hp: 100, move: 5, evade: 22, defense: 3, damage: 16, accuracy: 16, xp: 100, credits: 100, ranged: true
    ),
    self.new(
      name: "Blue Slime",
      slug: "blue_slime",
      hp: 100, move: 5, evade: 22, defense: 3, damage: 16, accuracy: 16, xp: 200, credits: 200
    ),
    self.new(
      name: "Green Dragon",
      slug: "green_dragon",
      hp: 400, move: 6, evade: 23, defense: 5, damage: 20, accuracy: 17, xp: 1000, credits: 1000, ranged: true
    ),
    self.new(
      name: "Red Dragon",
      slug: "red_dragon",
      hp: 750, move: 6, evade: 24, defense: 5, damage: 25, accuracy: 17, xp: 2000, credits: 2000, ranged: true
    ),
    self.new(
      name: "???",
      slug: "shadow_boss",
      hp: 999, move: 6, evade: 25, defense: 5, damage: 32, accuracy: 18, xp: 5000, credits: 5000, ranged: true
    )
  ]
    
  MONSTER_HASH = ALL_MONSTERS.reduce({}) do |memo, e| 
    memo[e.slug.to_sym] = e
    memo
  end

  def self.find(slug)
    return nil if slug.nil?
    MONSTER_HASH[slug.to_sym]
  end
end
