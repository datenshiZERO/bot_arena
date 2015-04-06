class Encounter
  attr_reader :wave, :monster_slug, :count

  def initialize(attr)
    @wave = attr[0]
    @monster_slug = attr[1]
    @count = attr[2]
  end

  def monster
    Monster.find(monster_slug.to_sym)
  end

  def self.generate_encounters(encounter_list)
    encounter_list.map { |e| Encounter.new(e) }
  end
end
