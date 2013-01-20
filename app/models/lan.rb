class Lan < ActiveRecord::Base
  attr_accessible :endtime, :place, :starttime

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
end

