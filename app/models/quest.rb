class Quest < ActiveRecord::Base
  has_many :encounters
  has_many :raids
end
