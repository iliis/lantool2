class LanController < ApplicationController
  protect_from_forgery

  before_filter :set_short_descr, :only => [:register, :participants]

  def register
    if request.post? and Lan.current and Lan.current.registration_open
      user = User.new
      user.name  = params[:full_name]
      user.nick  = params[:nick]
      user.email = params[:email]

      att = Attendance.new
      att.days_registered = params[:duration]
      att.comment         = params[:comment]
      att.user            = user
      att.lan             = Lan.current

      if user.save and att.save
        render 'registration_successfull'
      else
        @full_name = user.name
        @nick      = user.nick
        @email     = user.email
        @duration  = att.days_registered
        @comment   = att.comment

        @errors    = user.errors.messages.merge att.errors.messages
      end
    end
  end

  def participants
    if Lan.current
      @participants = Lan.current.attendances
    else
      @participants = []
    end
  end

  def mailinglist
    @mailinglist_entry = Mailinglist.new
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
