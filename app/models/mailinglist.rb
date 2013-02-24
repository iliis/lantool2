require 'valid_email'

class Mailinglist < ActiveRecord::Base
  attr_accessible :email, :name

  validates :name,  :presence => true
  validates :email, :presence => true,
                    :email => true,
                    :uniqueness => true

  def self.send_to_all(subject, message)
    Mailinglist.all.each do |u|
      LanMailer.enqueue_general_mail_to_user(u, subject, message)
    end
    LanMailer.start_processing
  end
end
