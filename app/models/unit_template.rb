class UnitTemplate
  attr_reader :name, :slug, :points, :price, :kill_requirement, 
    :mission_requirement, :hp, :evade, :move, :defense,
    :weapon_points, :armor_points, :mobility_points, :icon_class

  def initialize(name:, slug:, points: 3, price: 100, kill_requirement: 0, 
      mission_requirement: 0, hp: 10, evade: 10, move: 2, defense: 0,
      weapon_default: "dagger", weapon_points: 2, armor_default: "clothes",
      armor_points: 2, mobility_default: "boots", mobility_points: 2, icon_class: "")

    @name = name
    @slug = slug
    @points = points
    @price = price
    @kill_requirement = kill_requirement
    @mission_requirement = mission_requirement
    @hp = hp
    @evade = evade
    @move = move
    @defense = defense
    @weapon_default = weapon_default
    @weapon_points = weapon_points
    @armor_default = armor_default
    @armor_points = armor_points
    @mobility_default = mobility_default
    @mobility_points = mobility_points
    @icon_class = icon_class
  end

  ALL_TEMPLATES = [
    self.new(
      name: "Novice Warrior",
      slug: "novice_warrior"
    ),
    self.new(
      name: "Novice Skirmisher",
      slug: "novice_skirmisher",
      mission_requirement: 10,
      evade: 12,
      move: 3,
      weapon_default: "shuriken",
      mobility_points: 3,
      mobility_default: "gloves",
      icon_class: "skirmisher"
    ),
    self.new(
      name: "Novice Sentinel",
      slug: "novice_sentinel",
      kill_requirement: 5,
      mission_requirement: 5,
      hp: 15,
      evade: 8,
      armor_points: 3,
      armor_default: "leather_armor",
      icon_class: "sentinel"
    ),
    self.new(
      name: "Novice Mercenary",
      slug: "novice_mercenary",
      kill_requirement: 10,
      hp: 8,
      weapon_points: 3,
      weapon_default: "spear",
      icon_class: "mercenary"
    ),
    self.new(
      name: "Regular Warrior",
      slug: "regular_warrior",
      kill_requirement: 20,
      mission_requirement: 20,
      hp: 20,
      evade: 12,
      price: 800,
      points: 6,
      weapon_points: 3,
      weapon_default: "spear",
      armor_points: 3,
      armor_default: "leather_armor",
      mobility_points: 3,
      mobility_default: "gloves",
      icon_class: "regular"
    ),
    self.new(
      name: "Regular Skirmisher",
      slug: "regular_skirmisher",
      kill_requirement: 20,
      mission_requirement: 40,
      hp: 20,
      evade: 15,
      move: 3,
      price: 1000,
      points: 6,
      weapon_points: 3,
      weapon_default: "bow",
      armor_points: 3,
      armor_default: "leather_armor",
      mobility_points: 5,
      mobility_default: "sabaton",
      icon_class: "skirmisher regular"
    ),
    self.new(
      name: "Regular Sentinel",
      slug: "regular_sentinel",
      kill_requirement: 30,
      mission_requirement: 30,
      hp: 30,
      evade: 10,
      defense: 1,
      price: 1000,
      points: 6,
      weapon_points: 3,
      weapon_default: "spear",
      armor_points: 5,
      armor_default: "banded_mail",
      mobility_points: 3,
      mobility_default: "gloves",
      icon_class: "sentinel regular"
    ),
    self.new(
      name: "Regular Mercenary",
      slug: "regular_mercenary",
      kill_requirement: 40,
      mission_requirement: 20,
      hp: 15,
      price: 1000,
      points: 6,
      weapon_points: 5,
      weapon_default: "sword",
      armor_points: 3,
      armor_default: "leather_armor",
      mobility_points: 3,
      mobility_default: "gloves",
      icon_class: "mercenary regular"
    ),
    self.new(
      name: "Veteran Warrior",
      slug: "veteran_warrior",
      kill_requirement: 100,
      mission_requirement: 200,
      hp: 50,
      evade: 14,
      move: 3,
      defense: 1,
      price: 6400,
      points: 10,
      weapon_points: 5,
      weapon_default: "sword",
      armor_points: 5,
      armor_default: "banded_mail",
      mobility_points: 5,
      mobility_default: "sabaton",
      icon_class: "veteran"
    ),
    self.new(
      name: "Veteran Skirmisher",
      slug: "veteran_skirmisher",
      kill_requirement: 100,
      mission_requirement: 400,
      hp: 50,
      evade: 18,
      move: 4,
      defense: 1,
      price: 8000,
      points: 10,
      weapon_points: 5,
      weapon_default: "war_bow",
      armor_points: 5,
      armor_default: "banded_mail",
      mobility_points: 8,
      mobility_default: "boots_of_haste",
      icon_class: "skirmisher veteran"
    ),
    self.new(
      name: "Veteran Sentinel",
      slug: "veteran_sentinel",
      kill_requirement: 150,
      mission_requirement: 300,
      hp: 75,
      evade: 12,
      move: 3,
      defense: 2,
      price: 8000,
      points: 10,
      weapon_points: 5,
      weapon_default: "sword",
      armor_points: 8,
      armor_default: "cuirass",
      mobility_points: 5,
      mobility_default: "sabaton",
      icon_class: "sentinel veteran"
    ),
    self.new(
      name: "Veteran Mercenary",
      slug: "veteran_mercenary",
      kill_requirement: 200,
      mission_requirement: 200,
      hp: 40,
      move: 3,
      defense: 1,
      price: 8000,
      points: 10,
      weapon_points: 8,
      weapon_default: "battle_axe",
      armor_points: 5,
      armor_default: "banded_mail",
      mobility_points: 5,
      mobility_default: "sabaton",
      icon_class: "mercenary veteran"
    ),
    self.new(
      name: "Elite Warrior",
      slug: "elite_warrior",
      kill_requirement: 500,
      mission_requirement: 1000,
      hp: 100,
      evade: 16,
      move: 3,
      defense: 1,
      price: 40000,
      points: 20,
      weapon_points: 8,
      weapon_default: "battle_axe",
      armor_points: 8,
      armor_default: "cuirass",
      mobility_points: 8,
      mobility_default: "boots_of_haste",
      icon_class: "elite"
    ),
    self.new(
      name: "Elite Skirmisher",
      slug: "elite_skirmisher",
      kill_requirement: 500,
      mission_requirement: 2000,
      hp: 100,
      evade: 21,
      move: 5,
      defense: 1,
      price: 50000,
      points: 20,
      weapon_points: 8,
      weapon_default: "ice_staff",
      armor_points: 8,
      armor_default: "cuirass",
      mobility_points: 13,
      mobility_default: "gloves_of_accuracy",
      icon_class: "skirmisher elite"
    ),
    self.new(
      name: "Elite Sentinel",
      slug: "elite_sentinel",
      kill_requirement: 750,
      mission_requirement: 1500,
      hp: 150,
      evade: 14,
      move: 3,
      defense: 2,
      price: 50000,
      points: 20,
      weapon_points: 8,
      weapon_default: "battle_axe",
      armor_points: 13,
      armor_default: "full_plate_mail",
      mobility_points: 8,
      mobility_default: "boots_of_haste",
      icon_class: "sentinel elite"
    ),
    self.new(
      name: "Elite Mercenary",
      slug: "elite_mercenary",
      kill_requirement: 1000,
      mission_requirement: 1000,
      hp: 80,
      move: 3,
      defense: 1,
      price: 50000,
      points: 20,
      weapon_points: 13,
      weapon_default: "great_sword",
      armor_points: 8,
      armor_default: "cuirass",
      mobility_points: 8,
      mobility_default: "boots_of_haste",
      icon_class: "mercenary elite"
    )
  ]

  TEMPLATE_HASH = ALL_TEMPLATES.reduce({}) do |memo, t| 
    memo[t.slug.to_sym] = t
    memo
  end

  def self.find(slug)
    return nil if slug.nil?
    TEMPLATE_HASH[slug.to_sym]
  end

  def weapon_default
    Equipment.find(@weapon_default)
  end

  def armor_default
    Equipment.find(@armor_default)
  end

  def mobility_default
    Equipment.find(@mobility_default)
  end

  def full_price
    [weapon_default, armor_default, mobility_default].compact.sum(&:price) + price
  end


end
