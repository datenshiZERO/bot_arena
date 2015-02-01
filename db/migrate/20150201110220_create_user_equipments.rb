class CreateUserEquipments < ActiveRecord::Migration
  def change
    create_table :user_equipments do |t|
      t.references :user, index: true
      t.references :equipment, index: true
      t.references :unit, index: true

      t.timestamps null: false
    end
    add_foreign_key :user_equipments, :users
    add_foreign_key :user_equipments, :equipment
    add_foreign_key :user_equipments, :units
  end
end
