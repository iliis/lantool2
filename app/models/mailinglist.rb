require 'valid_email'

class Mailinglist < ActiveRecord::Base
  attr_accessible :email, :name

  validates :name,  :presence => true
  validates :email, :presence => true,
                    :email => true,
                    :uniqueness => true

  def self.send_to_all(subject, message)
    Mailinglist.all.each do |u|
      LanMailer.general_mail(u, subject, message)
    end
  end
end
