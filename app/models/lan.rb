class Lan < ActiveRecord::Base
  attr_accessible :endtime, :place, :starttime
  validates :starttime, :presence => true
  validates :endtime,   :presence => true
  validate  :start_before_end?

  has_many :attendances
  has_many :users, :through => :attendances

  def self.current
    # TODO: chache this. at least put it in @some_var
    if Settings.current_lan
      Lan.find(Settings.current_lan)
    end
  end

  def short_descr
    # eg. 'Januar 2012, Winterthur'
    # TODO: add short_location or something to Lan instead of hardcoding this here
    self.starttime.strftime('%B %Y') + ', Winterthur'
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

