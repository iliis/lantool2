class UserActivity < ActiveRecord::Base
  attr_accessible :day, :hour, :user, :activity_count

  belongs_to :user

  validates :day, :hour, :user, :presence => true

  def set_now
    self.day  = Date.today
    self.hour = Time.now.hour
  end

  def self.update(user, ip)
    res = user.activities.where(:day => Date.today, :hour => Time.now.hour).update_all('activity_count = activity_count + 1')

    if res == 0
      # no entry in DB for specific time slot
      a = UserActivity.new
      a.activity_count = 1
      a.set_now
      a.user = user 
      a.save
    elsif res > 1
      raise "Corrupt UserActivity table. #{res} entries matching User #{user.id} at day = '#{Date.today}' and hour = '#{Time.now.hour}'."
    end

    HostActivity.update_from_user(user, ip)
  end
end
