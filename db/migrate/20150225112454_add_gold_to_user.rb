class AddGoldToUser < ActiveRecord::Migration
  def change
    add_column :users, :gold, :integer, default: 0
  end
end
