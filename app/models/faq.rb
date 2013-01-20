class FAQ < ActiveRecord::Base
  attr_accessible :answer, :question

  validates :question, :answer, :presence => true
end
