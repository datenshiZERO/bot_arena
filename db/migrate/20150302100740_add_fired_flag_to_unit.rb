class AddFiredFlagToUnit < ActiveRecord::Migration
  def change
    add_column :units, :fired, :boolean, default: false
  end
end
