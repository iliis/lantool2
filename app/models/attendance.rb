class Attendance < ActiveRecord::Base
  belongs_to :user
  belongs_to :lan

  attr_accessible :comment, :days_participated, :days_registered, :fee, :paid
end
