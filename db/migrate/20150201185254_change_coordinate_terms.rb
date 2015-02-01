class ChangeCoordinateTerms < ActiveRecord::Migration
  def change
    rename_column :arenas, :x, :columns
    rename_column :arenas, :y, :rows
  end
end
