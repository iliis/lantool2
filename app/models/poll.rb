class Poll < ActiveRecord::Base
  belongs_to :owner, :class_name => 'User'
  belongs_to :lan

  attr_accessible :expiration_date, :title, :type

  validates :owner, :presence => true
  validates :lan,   :presence => true
  validates :expiration_date, :presence => true
  validate  :expiration_in_future

private
  def expiration_in_future
	  if expiration_date and expiration_date <= DateTime.now
		  errors.add(:expiration_date, "muss in der Zukunft liegen")
	  end
  end
end
