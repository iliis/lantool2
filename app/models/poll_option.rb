class PollOption < ActiveRecord::Base
  attr_accessible :text

  belongs_to :poll
  has_many :votes, :dependent => :destroy, :class_name => "PollVote"

  validates :text, :presence => true
  validates :poll, :presence => true
end
