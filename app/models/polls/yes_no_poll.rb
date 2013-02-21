class YesNoPoll < Poll
	# simple True/False question
  
  after_create :create_options
  
  def percent_yes
    self.yes_votes.count / self.votes.count
  end

  def yes_votes
    # this looks like it could be implemented in a less verbose and nested way...
    self.votes.where(:option_id => self.options.where(:text => 'Ja'))
  end

  def no_votes
    self.votes.where(:option_id => self.options.where(:text => 'Nein'))
  end

  def readable_type
    "Ja / Nein"
  end

private

  def create_options
    add_option('Ja')
    add_option('Nein')
  end
end
