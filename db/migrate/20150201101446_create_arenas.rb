class CreateArenas < ActiveRecord::Migration
  def change
    create_table :arenas do |t|
      t.string :name
      t.string :slug
      t.string :mode
      t.integer :x
      t.integer :y
      t.text :layout
      t.integer :points_max, default: 3
      t.integer :points_min, default: 3
      t.integer :xp_join, default: 1
      t.integer :xp_kill, default: 1
      t.integer :credits_kill, default: 10
      t.integer :xp_win, default: 1
      t.integer :credits_win, default: 10
      t.integer :xp_survive, default: 1
      t.integer :credits_survive, default: 10
      t.integer :team_count, default: 1
      t.integer :players_min, default: 1
      t.integer :minutes_interval, default: 5

      t.timestamps null: false
    end

    add_index :arenas, :name
    add_index :arenas, :slug, unique: true
  end
end
