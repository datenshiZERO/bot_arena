class Quest < ActiveRecord::Base
  has_many :encounters
end
