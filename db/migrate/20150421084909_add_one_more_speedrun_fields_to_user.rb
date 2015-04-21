class AddOneMoreSpeedrunFieldsToUser < ActiveRecord::Migration
  def change
    add_column :users, :most_efficient_speedrun_at, :datetime
  end
end
