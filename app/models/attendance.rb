class Attendance < ActiveRecord::Base
  belongs_to :user
  belongs_to :lan

  attr_accessible :comment, :days_participated, :days_registered, :fee, :paid

  # make days_registered maximum dependent on Lan.current
  validates :days_registered, :numericality => { :greater_than => 0, :smaller_than => 4 }
  validates :comment, :length => {:maximum => 300 }
  validates :user_email, uniqueness: true
end
