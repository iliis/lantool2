class LanController < ApplicationController
  protect_from_forgery

  before_filter :set_short_descr, :only => [:register, :participants]
  before_filter :authenticate_admin, :only => [:new, :create, :edit, :update]

  def index
    @all_lans = Lan.all
  end

  def show
    @lan = Lan.find_by_id(params[:id])
  end

  def register
    @lan = Lan.current

    if request.post? and Lan.current and Lan.current.registration_open

      att = Attendance.new
      att.days_registered = params[:duration]
      att.comment         = params[:comment]
      # user is linked/created at first login (signup at User#new)
      # att.user            = user
      att.lan             = Lan.current
      att.user_name       = params[:full_name]
      att.user_nick       = params[:nick]
      att.user_email      = params[:email]
      
      if att.save
        LanMailer.registration_confirmation(att)
        render 'registration_successfull'
      else
        @full_name = att.user_name
        @nick      = att.user_nick
        @email     = att.user_email
        @duration  = att.days_registered
        @comment   = att.comment

        @errors    = att.errors.full_messages
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
    @faqs = Faq.all
  end

  def games
    @games = Game.all
  end
  
  def new
    @lan = Lan.new
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

  def edit
    @lan = Lan.find(params[:id])
  end

  def update
    @lan = Lan.find(params[:id])

    if @lan.update_attributes(params[:lan])
      if params[:set_as_current]
        @lan.current!
      end

      redirect_to @lan
    else
      render :action => :edit
    end
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
