class Poll < ActiveRecord::Base
  belongs_to :owner, :class_name => 'User'
  belongs_to :lan

  attr_accessible :expiration_date, :title, :type

  validates :owner, :presence => true
  validates :lan,   :presence => true
  validates :type,  :presence => true
  validates :expiration_date, :presence => true
  validate  :expiration_in_future

  def to_partial_path
    "polls/#{self.class.name.underscore}"
  end

  def readable_type
    # return type in German (or whatever)
    # maybe use proper internalization here and specify subtypes in translation file (using generic stuff here)
    self.class.name
  end

private
  def expiration_in_future
	  if expiration_date and expiration_date <= DateTime.now
		  errors.add(:expiration_date, "muss in der Zukunft liegen")
	  end
  end
end
