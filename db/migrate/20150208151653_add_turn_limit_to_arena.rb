class AddTurnLimitToArena < ActiveRecord::Migration
  def change
    add_column :arenas, :turn_limit, :integer
  end
end
