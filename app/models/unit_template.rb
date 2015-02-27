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
end
