class UserEquipment < ActiveRecord::Base
  belongs_to :user
  belongs_to :equipment
  belongs_to :unit
end
