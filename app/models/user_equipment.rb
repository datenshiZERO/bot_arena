class UserEquipment < ActiveRecord::Base
  belongs_to :user
  belongs_to :unit

  [ :name, :slug, :slot, :points, :price, :accuracy, :damage, 
    :range_min, :range_max, :bonus_hp, :bonus_evade, :bonus_move, 
    :bonus_defense, :bonus_accuracy, :icon_class ].each do |m|
    define_method m do
      @base ||= Equipment.find(equipment_slug)
      return nil if @base.nil?
      @base.send(m)
    end
  end
end
