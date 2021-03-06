require 'valid_email'

class Mailinglist < ActiveRecord::Base
  attr_accessible :email, :name

  validates :name,  :presence => true
  validates :email, :presence => true,
                    :email => true,
                    :uniqueness => true

  def self.send_to_all(subject, message, exclude_registered=false)

    users = exclude_registered ? Mailinglist.all_without_registered : Mailinglist.all

    users.each do |u|
      LanMailer.enqueue_general_mail_to_user(u, subject, message)
    end

    LanMailer.start_processing
  end

  def self.send_to_registered_users(subject, message)
    Lan.current.attendances.each do |a|
      mu = Mailinglist.new
      mu.name  = a.user_name
      mu.email = a.user_email
      LanMailer.enqueue_general_mail_to_user(mu, subject, message)
    end
    LanMailer.start_processing
  end

  def self.all_without_registered
    if Lan.current.attendances.any?
      Mailinglist.where('email NOT IN (?)', Lan.current.attendances.select(:user_email).map(&:user_email))
    else
      Mailinglist.all
    end
  end
end
