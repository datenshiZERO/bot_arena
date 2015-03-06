class Encounter < ActiveRecord::Base
  belongs_to :quest

  def monster
    Monster.find(monster_slug.to_sym)
  end
end
