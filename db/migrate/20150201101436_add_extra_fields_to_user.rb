class AddExtraFieldsToUser < ActiveRecord::Migration
  def change
    add_column :users, :username, :string
    add_column :users, :credits, :integer, default: 0
    add_column :users, :total_xp, :integer, default: 0
    add_column :users, :total_missions, :integer, default: 0
    add_column :users, :total_kills, :integer, default: 0

    add_index :users, :username, unique: true
  end
end
