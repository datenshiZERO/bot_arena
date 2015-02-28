class Battle < ActiveRecord::Base
  belongs_to :arena
  has_many :unit_battle_outcomes

  def battle_id
    "#{arena.name}##{id}"
  end
end
