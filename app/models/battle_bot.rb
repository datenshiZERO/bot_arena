class BattleBot < ActiveRecord::Base
  belongs_to :arena
  belongs_to :unit_template
end
