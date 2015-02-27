class BattleBot < ActiveRecord::Base
  belongs_to :arena

  def unit_template
    UnitTemplate.find(template_slug)
  end
end
