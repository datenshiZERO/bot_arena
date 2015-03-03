class Battle < ActiveRecord::Base
  belongs_to :arena
  has_many :unit_battle_outcomes, dependent: :destroy

  def battle_id
    "#{arena.name}##{id}"
  end

  def grouped_outcomes
    unit_battle_outcomes.group_by { |t| t.team }
  end
end
