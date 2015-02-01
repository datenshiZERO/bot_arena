class CreateBattles < ActiveRecord::Migration
  def change
    create_table :battles do |t|
      t.references :arena, index: true
      t.string :outcome
      t.text :battle_log

      t.timestamps null: false
    end
    add_foreign_key :battles, :arenas
  end
end
