class AddStageToUser < ActiveRecord::Migration
  def change
    add_column :users, :stage, :integer, default: 1
  end
end
