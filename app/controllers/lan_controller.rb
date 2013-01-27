class LanController < ApplicationController
  protect_from_forgery

  before_filter :set_short_descr, :only => [:register, :participants]

  def register
    @lan = Lan.current

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
      
      user_ok = user.save
      att_ok  = att.save

      if user_ok and att_ok
        LanMailer.registration_confirmation(att)
        render 'registration_successfull'
      else
        #undo inserts
        user.delete   if user_ok
        att_ok.delete if att_ok

        @full_name = user.name
        @nick      = user.nick
        @email     = user.email
        @duration  = att.days_registered
        @comment   = att.comment

        @errors    = user.errors.full_messages + att.errors.full_messages
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

  def new
	@lan = Lan.new
    @lan.description = render_to_string :partial => 'new_template'
  end
  
  def create
    @lan = Lan.new(params[:lan])

    if @lan.save
      flash[:notice] = 'gespeichert'
    else
      @errors = @lan.errors.full_messages
    end

    render :action => 'new'
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

  def send_registration_confirmation_mail(reg)
    mail(:to => 'samuelbryner@gmx.ch', :from => 'iliis.junk@gmail.com', :subject => 'rails mail test')
  end

end
