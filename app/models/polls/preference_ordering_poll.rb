#!/bin/env ruby
#encoding: utf-8

class PreferenceOrderingPoll < Poll
	# options are fixed by creator
	# users can set a relative ordering of options (simple linear order? directed acyclic graph?)

  def readable_type
    "Präferenzen sortieren (Condorcet / Schulze)"
  end

  def user_count
    if options.count > 0 # shouldn't happen, but...
      return votes.count / options.count
    else
      return 0
    end
  end


  def vote(data, user)
    if data.nil? or data.strip.empty?
      raise "Leere Stimme abgegeben."
      return false
    end
    # data should be a string of comma-separated vote-IDs
    # e.g. "40,37,38,39"
    data_list = data.split(",")

    # user just reorders all available options => count must remain the same
    if data_list.count != self.options.count
      raise "Ungültige Anzahl an Stimmen abgegeben. Erwarte "+self.options.count+" anstatt "+data_list.count
      return false
    end

    # attach weight in order provided by voter (less means higher preference)
    i = 1
    data_list.each { |o|
      # verify if ID is actually a valid vote ID of this poll
      unless self.options.exists?(o)
        raise "Ungültige Stimme abgegeben. '" + o + "' ist keine gültige ID."
        return false
      end

      v = PollVote.new
      v.user = user
      v.poll = self
      v.option = self.options.find(o)
      v.weight = i
      i = i + 1
      if !v.save
        raise "Deine Stimme konnte nicht richtig gezählt werden. Dies ist ein Bug, bitte melden! (" + v.errors.full_messages.join(", ") + ")"
        return false
      end
    }

    # vote successful
    return true
  end

  # returns an ordered list of all options with the most prefered first
  # it is an implementation of the Schulze method
  # (https://en.wikipedia.org/wiki/Schulze_method)
  # this method assumes there is a total order (no ties, no cycles)!
  def schulze_ranking
    spath = self.strongest_path

    return options.sort do |a,b|
      case
      when spath[[a,b]] < spath[[b,a]]
        1
      when spath[[a,b]] > spath[[b,a]]
        -1
      else
        0
      end
    end
  end

  def strongest_path
    # compute the strongest paths
    # these are orderings of options where 
    strongest_path = Hash.new 0 # zero (default) means no strongest path

    options.each do |optA|
      options.each do |optB|
        if optA != optB
          dAB = count_preference_over(optA, optB)
          dBA = count_preference_over(optB, optA)
          if dAB > dBA
            strongest_path[[optA, optB]] = dAB
          else
            strongest_path[[optA, optB]] = 0
          end
        end
      end
    end

    options.each do |optA|
      options.each do |optB|
        if optA != optB
          options.each do |optC|
            if optA != optC and optB != optC
              pBC = strongest_path[[optB, optC]]
              pBA = strongest_path[[optB, optA]]
              pAC = strongest_path[[optA, optC]]
              strongest_path[[optB, optC]] = [pBC, [pBA, pAC].min].max
            end
          end
        end
      end
    end

    return strongest_path
  end

  # returns the number of voters who prefer option A over option B
  # lower weight means higher preference
  def count_preference_over(optA, optB)
    PollVote.find_by_sql(["SELECT * FROM
                         poll_votes AS v1
                         INNER JOIN poll_votes AS v2
                         ON v1.user_id = v2.user_id
                         WHERE v1.poll_option_id = ?
                         AND   v2.poll_option_id = ?
                         AND v1.weight < v2.weight", optA.id, optB.id]).count
  end
end
