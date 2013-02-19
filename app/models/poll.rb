require 'action_view'
include ActionView::Helpers::DateHelper

class Poll < ActiveRecord::Base
  belongs_to :owner, :class_name => 'User'
  belongs_to :lan

  has_many :options, :dependent => :destroy, :class_name => "PollOption"
  has_many :votes,   :dependent => :destroy, :class_name => "PollVote"

  attr_accessible :expiration_date, :title, :type, :description
  attr_accessible :expiration_in_hours, :expiration_in_minutes

  validates :owner, :lan, :type, :title, :expiration_date, :presence => true
  validate  :expiration_in_future

  def to_partial_path
    "polls/#{self.class.name.underscore}"
  end

  def readable_type
    # return type in German (or whatever)
    # maybe use proper internalization here and specify subtypes in translation file (using generic stuff here)
    self.class.name
  end

  def all_types
    # list all descendants of this class
    # descendants only works with Application.config.cache_classes = true, otherwise we get an empty list
    # so for development we need a workaround...
    Rails.application.eager_load! if Rails.env.development?
    return Poll.descendants.collect {|p| [p.new.readable_type, p.name]}
  end

  def expired?
    expiration_date.past?
  end

  def expiration_in
    # give something like "2 days, 1h 13m"
    distance_of_time_in_words_to_now(self.expiration_date)
  end

  def expiration_in=(t)
    self.expiration_date = DateTime.parse(t)
  end

  # TODO: these are very inexact, this results in minutes 'falling off' when updating a form,
  # also gives wrong results for past dates
  def expiration_in_hours
    ((expiration_date - DateTime.now) / 1.hour).floor if expiration_date
  end

  def expiration_in_minutes
    (((expiration_date - DateTime.now) / 1.hour - expiration_in_hours) * 1.minute).floor if expiration_date
  end

  def expiration_in_hours=(h)
    self.expiration_date ||= DateTime.now
    self.expiration_date += h.to_i.hour
  end

  def expiration_in_minutes=(m)
    self.expiration_date ||= DateTime.now
    self.expiration_date += m.to_i.minute
  end

  def countdown_html
    ('<time class="countdown" datetime="'+expiration_date.getutc.iso8601.to_s + \
     '" timestamp="'+expiration_date.to_i.to_s+'">' + \
     expiration_in+'</time>').html_safe
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
		  errors.add(:expiration_date, "muss in der Zukunft liegen (eingegebenes Ende: vor "+expiration_in+")")
	  end
  end

  # call this after poll is created (PollOption needs index of this Poll)
  def add_option(text)
    o = PollOption.new(:text => text)
    o.poll = self
    o.save
  end
end
