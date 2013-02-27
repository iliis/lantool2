#!/bin/env ruby
#encoding: utf-8

class MultiVotePoll < Poll
	# same as SingleVotePoll, but users can choose/not-choose multiple options
	# see also RedditPoll for +1/0/-1 instead of +1/0 vote

  attr_accessible :options_str
  attr_accessor   :options_str

  after_create do
    options_str.split(/\r?\n/).each { |o| add_option(o) }
  end

  def readable_type
    "Mehrfache Abstimmung"
  end

  def vote(data, user)
    raise "Kann nicht abstimmen." if !self.can_be_voted_on_from?(user)

    data = [] if data.nil?

    data.each do |d|
      v = PollVote.new
      v.user = user
      v.poll = self

      o = self.options.find(d)
      if o.present?
        v.option = o
      else
        raise "Auswahl nicht gefunden: Poll "+self.id.to_s+" hat keine Option "+data
        return false
      end

      unless v.save
        raise "Deine Stimme konnte nicht gezählt werden."
        return false
      end
    end

    return true
  end
end
