class AddTutorialLevelToUser < ActiveRecord::Migration
  def change
    add_column :users, :tutorial_level, :integer, default: 0
  end
end
