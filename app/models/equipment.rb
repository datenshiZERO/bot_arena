class Equipment 

  attr_reader :name, :slug, :slot, :points, :price, :accuracy, :damage, 
    :range_min, :range_max, :bonus_hp, :bonus_evade, :bonus_move, 
    :bonus_defense, :bonus_accuracy

  SLOTS = ["weapon", "armor", "mobility"]

  def initialize(name:, slug:, slot:, points:, price:, accuracy: nil, damage: nil,
      range_min: nil, range_max: nil, bonus_hp: 0, bonus_evade: 0, bonus_move: 0, 
      bonus_defense: 0, bonus_accuracy: 0)
    @name = name
    @slug = slug
    @slot = slot
    @points = points
    @price = price
    @accuracy = accuracy
    @damage = damage
    @range_min = range_min
    @range_max = range_max
    @bonus_hp = bonus_hp
    @bonus_evade = bonus_evade
    @bonus_move = bonus_move
    @bonus_defense = bonus_defense
    @bonus_accuracy = bonus_accuracy
  end

  def icon_class
    @slug
  end

  ALL_EQUIPMENT = [
    self.new(
      name: "Dagger", 
      slug: "dagger",
      slot: "weapon",
      points: 2,
      price: 10,
      accuracy: 10,
      damage: 2,
      range_min: 1,
      range_max: 1
    ),
    self.new(
      name: "Shuriken", 
      slug: "shuriken",
      slot: "weapon",
      points: 2,
      price: 10,
      accuracy: 10,
      damage: 2,
      range_min: 1,
      range_max: 1
    ),
    self.new(
      name: "Clothes", 
      slug: "clothes",
      slot: "armor",
      points: 2,
      price: 10,
      bonus_evade: 1
    ),
    self.new(
      name: "Boots", 
      slug: "boots",
      slot: "mobility",
      points: 2,
      price: 10,
      bonus_evade: 1,
      bonus_move: 1
    )
  ]

  EQUIPMENT_HASH = ALL_EQUIPMENT.reduce({}) do |memo, e| 
    memo[e.slug.to_sym] = e
    memo
  end

  def self.find(slug)
    return nil if slug.nil?
    EQUIPMENT_HASH[slug.to_sym]
  end
end
