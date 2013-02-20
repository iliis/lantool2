class RedditPoll < Poll
	# every user can up or downvote every option (+1/0/-1)
	# users can submit new options for voting
  
  def readable_type
    "Up/Downvote (Reddit-style)"
  end
end
