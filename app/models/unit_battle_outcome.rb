class UnitBattleOutcome < ActiveRecord::Base
  belongs_to :battle
  belongs_to :unit

  def unit_outcome_label
    "label label-#{outcome == 'killed' ? "danger" : "success"}"
  end

  def battle_outcome_label
    return "" if  team.nil?
    expected = "Team #{team.upcase} Wins"
    "label label-#{battle.outcome == expected ? "success" : "danger"}"
  end

  def parsed_details
    @parsed_details ||= JSON.parse(details)
  end

end
