#!/bin/env ruby
#encoding: utf-8

class PreferenceOrderingPoll < Poll
	# options are fixed by creator
	# users can set a relative ordering of options (simple linear order? directed acyclic graph?)

  def readable_type
    "Präferenzen sortieren (Condorcet / Schulze)"
  end
end
