class PollVote < ActiveRecord::Base
  attr_accessible :type

  belongs_to :poll
  belongs_to :user
  belongs_to :option, :class_name => "PollOption", :foreign_key => "poll_option_id"

  validates :poll, :user, :option, :presence => :true
end
