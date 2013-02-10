class PollsController < ApplicationController
  protect_from_forgery

  def index
    @polls = Lan.current.polls
  end
end
