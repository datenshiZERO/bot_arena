class AddExtraSpeedrunFieldsToUser < ActiveRecord::Migration
  def change
    add_column :users, :efficient_speedrun_time, :integer
    add_column :users, :efficient_speedrun_raid_count, :integer
    rename_column :users, :most_efficient_speedrun_at, :efficient_speedrun_at
  end
end
