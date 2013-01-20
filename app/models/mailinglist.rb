class Mailinglist < ActiveRecord::Base
  attr_accessible :email, :name

  validates :name,  :presence => true
  validates :email, :presence => true,
                    :email => true
end
