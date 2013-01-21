class Attendance < ActiveRecord::Base
  belongs_to :user
  belongs_to :lan

  attr_accessible :comment, :days_participated, :days_registered, :fee, :paid

  validate :days_registered, :numericality => { :only_integer => true, :greater_than => 0, :smaller_than => 4 }
  validate :user_not_already_registered

private
  def user_not_already_registered
    if user.attends?(lan)
      errors.add(:user, "already attending this LAN")
    end
  end
end
