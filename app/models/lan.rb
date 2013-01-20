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
end

