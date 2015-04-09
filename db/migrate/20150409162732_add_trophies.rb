class AddTrophies < ActiveRecord::Migration
  def change
    add_column :arenas, :trophies_1st, :integer, default: 5
    add_column :arenas, :trophies_2nd, :integer, default: 3
    add_column :arenas, :trophies_3rd, :integer, default: 1
    add_column :unit_battle_outcomes, :trophies, :integer, default: 0
    add_column :users, :total_trophies, :integer, default: 0
    add_column :users, :leaderboard_visible, :boolean, default: true

    add_index :users, :total_trophies
  end
end
