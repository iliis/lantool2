class LanController < ApplicationController
  protect_from_forgery

  before_filter :set_short_descr, :only => [:register, :participants]

  def register
  end

  def participants
  end

  def mailinglist
  end

  def faq
  end

  def games
    @games = Game.all
  end

private
  
  def set_short_descr
    l = Lan.current
    if l
      # eg. 'Januar 2012, Winterthur'
      # TODO: add short_location or something to Lan instead of hardcoding this here
      @short_descr = l.starttime.strftime('%B %Y') + ', Winterthur'
    else
      @short_descr = 'keine'
    end
  end

end
