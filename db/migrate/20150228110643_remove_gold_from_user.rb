class RemoveGoldFromUser < ActiveRecord::Migration
  def change
    remove_column :users, :gold
  end
end
