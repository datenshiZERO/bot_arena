class AddSpeedrunFieldsToUser < ActiveRecord::Migration
  def change
    add_column :users, :speedrun_start_at, :datetime
    add_column :users, :speedrun_time, :integer
    add_column :users, :speedrun_end_at, :datetime
    add_column :users, :best_speedrun_time, :integer
    add_column :users, :best_speedrun_at, :datetime
  end
end
