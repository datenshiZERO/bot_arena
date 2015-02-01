class BattleBot < ActiveRecord::Base
  belongs_to :battle
  belongs_to :unit_template
end
