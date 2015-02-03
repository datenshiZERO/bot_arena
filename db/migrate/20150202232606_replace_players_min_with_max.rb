class ReplacePlayersMinWithMax < ActiveRecord::Migration
  def change
    rename_column :arenas, :players_min, :players_max
  end
end
