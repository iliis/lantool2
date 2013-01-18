class Lan < ActiveRecord::Base
  attr_accessible :endtime, :place, :starttime

  has_many :attendances
  has_many :users, :through => :attendances
end

