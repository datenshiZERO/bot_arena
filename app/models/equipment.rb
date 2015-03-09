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
    @slug.gsub("_", "-")
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
      accuracy: 8,
      damage: 1,
      range_min: 1,
      range_max: 2
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
    ),
    self.new(
      name: "Spear", 
      slug: "spear",
      slot: "weapon",
      points: 3,
      price: 50,
      accuracy: 12,
      damage: 4,
      range_min: 1,
      range_max: 1
    ),
    self.new(
      name: "Bow", 
      slug: "bow",
      slot: "weapon",
      points: 3,
      price: 50,
      accuracy: 9,
      damage: 3,
      range_min: 2,
      range_max: 3
    ),
    self.new(
      name: "Leather Armor", 
      slug: "leather_armor",
      slot: "armor",
      points: 3,
      price: 50,
      bonus_evade: 2,
      bonus_defense: 1
    ),
    self.new(
      name: "Gloves", 
      slug: "gloves",
      slot: "mobility",
      points: 3,
      price: 50,
      bonus_evade: 1,
      bonus_accuracy: 1
    ),
    self.new(
      name: "Sword", 
      slug: "sword",
      slot: "weapon",
      points: 5,
      price: 300,
      accuracy: 14,
      damage: 8,
      range_min: 1,
      range_max: 1
    ),
    self.new(
      name: "War Bow", 
      slug: "war_bow",
      slot: "weapon",
      points: 5,
      price: 300,
      accuracy: 10,
      damage: 5,
      range_min: 2,
      range_max: 4
    ),
    self.new(
      name: "Banded Mail", 
      slug: "banded_mail",
      slot: "armor",
      points: 5,
      price: 300,
      bonus_evade: 3,
      bonus_defense: 1
    ),
    self.new(
      name: "Sabaton", 
      slug: "sabaton",
      slot: "mobility",
      points: 5,
      price: 300,
      bonus_evade: 1,
      bonus_defense: 1
    ),
    self.new(
      name: "Battle Axe", 
      slug: "battle_axe",
      slot: "weapon",
      points: 8,
      price: 1800,
      accuracy: 16,
      damage: 16,
      range_min: 1,
      range_max: 1
    ),
    self.new(
      name: "Ice Staff", 
      slug: "ice_staff",
      slot: "weapon",
      points: 8,
      price: 1800,
      accuracy: 11,
      damage: 10,
      range_min: 3,
      range_max: 4
    ),
    self.new(
      name: "Cuirass", 
      slug: "cuirass",
      slot: "armor",
      points: 8,
      price: 1800,
      bonus_evade: 4,
      bonus_defense: 2
    ),
    self.new(
      name: "Boots of Haste", 
      slug: "boots_of_haste",
      slot: "mobility",
      points: 8,
      price: 1800,
      bonus_evade: 2,
      bonus_move: 2
    ),
    self.new(
      name: "Great Sword", 
      slug: "great_sword",
      slot: "weapon",
      points: 13,
      price: 12000,
      accuracy: 18,
      damage: 32,
      range_min: 1,
      range_max: 2
    ),
    self.new(
      name: "Fire Staff", 
      slug: "fire_staff",
      slot: "weapon",
      points: 13,
      price: 12000,
      accuracy: 12,
      damage: 20,
      range_min: 3,
      range_max: 5
    ),
    self.new(
      name: "Full Plate Mail", 
      slug: "full_plate_mail",
      slot: "armor",
      points: 13,
      price: 12000,
      bonus_evade: 6,
      bonus_defense: 3
    ),
    self.new(
      name: "Gloves of Accuracy", 
      slug: "gloves_of_accuracy",
      slot: "mobility",
      points: 13,
      price: 12000,
      bonus_accuracy: 6
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
