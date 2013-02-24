class MailQueue < ActiveRecord::Base
  attr_accessible :content, :from, :subject, :to, :error

  validates :content, :from, :to, :subject, :presence => true
end
