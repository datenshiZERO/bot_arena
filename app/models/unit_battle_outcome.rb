class UnitBattleOutcome < ActiveRecord::Base
  belongs_to :battle
  belongs_to :unit
end
