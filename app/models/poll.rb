class Poll < ActiveRecord::Base
  belongs_to :owner, :class_name => 'User'
  belongs_to :lan

  has_many :options, :dependent => :destroy, :class_name => "PollOption"
  has_many :votes,   :dependent => :destroy, :class_name => "PollVote"

  attr_accessible :expiration_date, :title, :type

  validates :owner, :lan, :type, :expiration_date, :presence => true
  validate  :expiration_in_future

  def to_partial_path
    "polls/#{self.class.name.underscore}"
  end

  def readable_type
    # return type in German (or whatever)
    # maybe use proper internalization here and specify subtypes in translation file (using generic stuff here)
    self.class.name
  end

  def expired?
    expiration_date <= DateTime.now
  end

  def countdown_html
    ('<time class="countdown" datetime="'+expiration_date.getutc.iso8601.to_s + \
     '" timestamp="'+expiration_date.to_i.to_s+'">' + \
     expiration_date.to_s+'</time>').html_safe
  end

  # overwrite this method if necessary
  def vote!(data, user)
    return false if user.has_voted_on?(self)

    v = PollVote.new
    v.user = user
    v.poll = self
    
    o = self.options.where(:text => data).limit(1).first
    if o.present?
      v.option = o
    else
      return false
    end

    v.save
  end

  def has_vote_from?(user)
    self.votes.where(:user_id => user).any?
  end

  def vote_from_user(user)
    # get [all] vote[s] from user for this Poll
    self.votes.where(:user_id => user)
  end

  def expiration_in_future
	  if expiration_date and expiration_date <= DateTime.now
		  errors.add(:expiration_date, "muss in der Zukunft liegen")
	  end
  end

  # call this after poll is created (PollOption needs index of this Poll)
  def add_option(text)
    o = PollOption.new(:text => text)
    o.poll = self
    o.save
  end
end
