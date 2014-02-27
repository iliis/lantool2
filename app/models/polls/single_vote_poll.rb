class SingleVotePoll < Poll
	# normal vote where each user can vote for one option
	# options are predefined by creator

  def readable_type
    "Normale Abstimmung"
  end
end
