class CreateBattleBots < ActiveRecord::Migration
  def change
    create_table :battle_bots do |t|
      t.references :arena, index: true
      t.references :unit_template, index: true
      t.boolean :filler, default: false
      t.integer :count, default: 0

      t.timestamps null: false
    end
    add_foreign_key :battle_bots, :arenas
    add_foreign_key :battle_bots, :unit_templates
  end
end
