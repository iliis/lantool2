class Lan < ActiveRecord::Base
  attr_accessible :endtime, :place, :starttime, :description, :registration_open
  validates :starttime, :presence => true
  validates :endtime,   :presence => true
  validate  :start_before_end?

  has_many :attendances, :dependent => :destroy
  has_many :users, :through => :attendances
  has_many :polls, :dependent => :destroy

  def self.current
    # TODO: chache this. at least put it in @some_var
    if Settings.current_lan
      Lan.find(Settings.current_lan)
    end
  end

  def current!
    Settings.current_lan = self.id
  end

  def time
    I18n.localize(self.starttime, :format => '%A, %d.')+' bis '+I18n.localize(self.endtime, :format => '%A, %d. %B %Y')
  end

  def short_descr
    # eg. 'Januar 2012, Winterthur'
    # TODO: add short_location or something to Lan instead of hardcoding this here
    I18n.localize(self.starttime, :format => '%B %Y') + ', ' + self.place
  end

  def users_not_attending
    User.where('`users`.`id` NOT IN (?)', Lan.current.attendances.select(:user_id).collect(&:user_id))
  end

  def total_days
    total_days = 0
    attendances.each do |a|
      if a.days_participated.nil? then
        raise "User has undefinded participation day count. Please fix this by going to 'Manage Attendances'"
      else
        total_days += a.days_participated
      end
    end

    return total_days
  end

private

  def start_before_end?
    if starttime and endtime
      if self.starttime >= self.endtime
        errors.add(:starttime, "has to be before endtime")
      end
    end
  end
end

