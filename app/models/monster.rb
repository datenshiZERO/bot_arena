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
      name: "Giant Rat",
      slug: "giant_rat",
      hp: 5,
      move: 2,
      evade: 8,
      damage: 2,
      accuracy: 8,
      xp: 8,
      credits: 4
    ),
    self.new(
      name: "Giant Spider",
      slug: "giant_spider",
      hp: 15,
      move: 2,
      evade: 9,
      damage: 3,
      accuracy: 9,
      xp: 15,
      credits: 10
    ),
    self.new(
      name: "Red Slime",
      slug: "red_slime",
      hp: 20,
      move: 3,
      evade: 10,
      damage: 4,
      accuracy: 10,
      xp: 25,
      credits: 20
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
