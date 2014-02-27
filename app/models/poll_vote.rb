class PollVote < ActiveRecord::Base
  # 'generic' attributes for special voting mechanims (e.g. type = 'upvote')
  attr_accessible :type, :weight

  belongs_to :poll
  belongs_to :user
  belongs_to :option, :class_name => "PollOption", :foreign_key => "poll_option_id"

  validates :poll, :user, :option, :presence => :true
end
