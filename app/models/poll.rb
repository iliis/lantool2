#!/bin/env ruby
#encoding: utf-8

require 'action_view'
include ActionView::Helpers::DateHelper

class Poll < ActiveRecord::Base
  belongs_to :owner, :class_name => 'User'
  belongs_to :lan

  has_many :options, :dependent => :destroy, :class_name => "PollOption"
  has_many :votes,   :dependent => :destroy, :class_name => "PollVote"

  attr_accessible :expiration_date, :title, :type, :description
  attr_accessible :expiration_in_hours, :expiration_in_minutes
  attr_accessor   :expiration_in_hours, :expiration_in_minutes

  before_validation do
    self.expiration_date = DateTime.now + expiration_in_hours.to_i.hours + expiration_in_minutes.to_i.minutes
  end

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

  def self.all_types
    # list all descendants of this class
    # descendants only works with Application.config.cache_classes = true, otherwise we get an empty list
    # so for development we need a workaround...
    Rails.application.eager_load! if Rails.env.development?
    return Poll.descendants
  end

  def self.all_types_for_select
    all_types.collect {|p| [p.new.readable_type, p.name]}
  end

  def self.class_from_string(type)
    c = type.constantize

    if c < Poll # only create subtypes of Poll (not arbitrary classes)
      c
    else
      nil
    end
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

  def countdown_html
    ('<time class="countdown" datetime="'+expiration_date.getutc.iso8601.to_s + \
     '" timestamp="'+expiration_date.to_i.to_s+'">' + \
     expiration_in+'</time>').html_safe
  end

  def custom_form
    'polls/new_forms/'+self.class.name.underscore
  end

  def custom_form_path
    Rails.root.join('app', 'views', 'polls', 'new_forms', "_"+self.class.name.underscore+".html.erb")
  end

  def has_custom_form?
    File.exists?(custom_form_path)
  end

  # overwrite this method if necessary
  # maybe implement better error handling than just throwing errors around...
  def vote(data, user)
    raise "already voted" if user.has_voted_on?(self)
    return false if user.has_voted_on?(self)

    v = PollVote.new
    v.user = user
    v.poll = self
    
    o = self.options.find(data)
    if o.present?
      v.option = o
    else
      raise "Auswahl nicht gefunden: Poll "+self.id.to_s+" hat keine Option "+data
      return false
    end

    unless v.save
      raise "Deine Stimme konnte nicht gezählt werden."
    end
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
