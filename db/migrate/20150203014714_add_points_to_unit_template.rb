class AddPointsToUnitTemplate < ActiveRecord::Migration
  def change
    add_column :unit_templates, :points, :integer, default: 3
  end
end
