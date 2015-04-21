class AddMoreSpeedrunFieldsToUser < ActiveRecord::Migration
  def change
    add_column :users, :speedrun_raid_count, :integer
    add_column :users, :best_speedrun_raid_count, :integer
  end
end
