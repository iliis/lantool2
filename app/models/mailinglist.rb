require 'valid_email'

class Mailinglist < ActiveRecord::Base
  attr_accessible :email, :name

  validates :name,  :presence => true
  validates :email, :presence => true,
                    :email => true,
                    :uniqueness => true

  def self.send_to_all(subject, message, exclude_registered=false)
    Mailinglist.all.each do |u|
      if !exclude_registered or (! Lan.current.users.find_by_email(u.email).present?)
        LanMailer.enqueue_general_mail_to_user(u, subject, message)
      end
    end
    LanMailer.start_processing
  end
end
