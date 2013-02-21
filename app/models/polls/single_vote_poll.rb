class SingleVotePoll < Poll
	# normal vote where each user can vote for one option
	# options are predefined by creator
  attr_accessible :options_str
  attr_accessor   :options_str

  after_create do
    options_str.split(/\r?\n/).each { |o| add_option(o) }
  end

  def readable_type
    "Normale Abstimmung"
  end
end
