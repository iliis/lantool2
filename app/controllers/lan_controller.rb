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
    @faqs = FAQ.all
  end

  def games
    @games = Game.all
  end

private
  
  def set_short_descr
    l = Lan.current
    if l
      @short_descr = l.short_descr
    else
      @short_descr = 'keine'
    end
  end

end
