require 'valid_email'

class User < ActiveRecord::Base
  attr_accessible :email, :name, :nick, :password

  has_many :attendances
  has_many :lans, :through => :attendances

  validates :name,  :presence => true
  validates :email, :presence => true,
                    :email => true

  validates :password, :presence => true,
                       :confirmation => true
end
