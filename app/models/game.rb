class Game < ActiveRecord::Base
  attr_accessible :description, :link, :name, :icon, :screenshot
  has_attached_file :icon
  has_attached_file :screenshot

  validates :name, :description, :presence => true
end
