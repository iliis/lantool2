
class MailQueue < ActiveRecord::Base
  include ActionView::Helpers

  attr_accessible :content, :from, :subject, :to, :error

  validates :content, :from, :to, :subject, :presence => true

  def clean_content
    strip_tags(self.content.gsub('<br>',"\n"))
  end
end
