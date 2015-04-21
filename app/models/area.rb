class Area
  attr_reader :name, :quests

  def self.all
    (0...AREAS.length).map { |i| Area.new(i) }
  end

  def initialize(id)
    @name = AREAS[id][:name]
    @quests = Quest.area(id)
  end

  AREAS = [
    { name: "Sewers", display_class: "sewers" }, 
    { name: "Forest", display_class: "forest" },
    { name: "Desert", display_class: "desert" },
    { name: "Haunted Castle", display_class: "castle" }
  ]
end
