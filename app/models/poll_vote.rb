class PollVote < ActiveRecord::Base
  attr_accessible :type

  belongs_to :poll
  belongs_to :user
  belongs_to :option, :class_name => "PollOption"

  validates :poll, :presence => :true
  validates :user, :presence => :true
  validates :option, :presence => true
end
