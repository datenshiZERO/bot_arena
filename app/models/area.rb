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
    { name: "Sewers" }, 
    { name: "Forest" },
    { name: "Desert" },
    { name: "Haunted Castle" }
  ]
end
