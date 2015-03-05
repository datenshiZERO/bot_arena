class Monster
  attr_reader :name, :slug, :hp, :move, :evade, :defense, :damage, :accuracy, 
    :ranged, :xp, :credits

  def initialize(name:, slug:, hp: 4, move: 1, evade: 6, damage: 1, accuracy: 6, 
      ranged: false, xp: 4, credits: 2)
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
