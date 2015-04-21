class AddWeeklyTrophiesToUser < ActiveRecord::Migration
  def change
    add_column :users, :weekly_trophies, :integer, default: 0
  end
end
