require 'valid_email'

class User < ActiveRecord::Base
  attr_accessible :email, :name, :nick, :password

  has_many :attendances
  has_many :lans, :through => :attendances

  validates :name,  :presence => true
  validates :email, :presence => true,
                    :email => true

  validates :password, :confirmation => true #, :presence => true

  def attends?(lan)
    lan.users.exists?(self) || lan.users.where(:name => self.name).any? || lan.users.where(:email => self.email).any?
  end
end
