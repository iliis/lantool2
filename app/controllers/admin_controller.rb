#!/usr/bin/env ruby
#encoding: utf-8

class AdminController < ApplicationController
  before_filter :authenticate_admin
  before_filter :check_if_lan_selected, :except => [:index]

  def index
  end

  def manage_attendances
    @attendances = Lan.current.attendances
  end

  def update_attendances
    @attendances = Attendance.update(params[:attendances].keys, params[:attendances].values).reject { |a| a.errors.empty? }
    if @attendances.empty?
      redirect_to :action => :manage_attendances
    else
      render :action => :manage_attendances
    end
  end

  def finances
    @lan = Lan.current
  end

  def update_finances
    @lan = Lan.find(params[:id])

    @lan.total_costs = params[:lan][:total_costs]
    if @lan.save
      flash[:notice] = "gespeichert"
    else
      @errors = @lan.errors
    end

    render :action => :finances
  end

  def calculate_attendance_fees
    @attendances = Lan.current.attendances

    total_costs = Lan.current.total_costs
    total_days  = Lan.current.total_days

    if total_costs.nil? or total_costs == 0
      raise "Bitte totale Kosten der aktuellen Lan setzten."
    end

    if total_days.nil? or total_days == 0
      raise "Bitte Zeitdauer der aktuellen Lan festlegen."
    end

    @attendances.each do |a|
      a.fee = ( total_costs / total_days * a.days_participated ).ceil
      a.save
    end

    render :action => :manage_attendances
  end

  def send_invoices
    @lan = Lan.current

    @message = params[:message]
    @subject = params[:subject]

    if !@message.blank? and !@subject.blank? and params[:edit].nil?

      @parsed_message = @message
      .gsub("$TOTAL_COSTS", @lan.total_costs.to_s)
      .gsub("$TOTAL_DAYS",  @lan.total_days.to_s)
      .gsub("$COST_PER_DAY", (@lan.total_costs / @lan.total_days).to_s )
      #.gsub(/\r?\n/,'<br>')

      @lan.attendances.each do |a|
        if a.fee.nil? or a.days_participated.nil?
          raise "User has undefinded participation day count. Please fix this by going to 'Manage Attendances'"
        end
      end

      if params[:confirm].nil?
        # show message confirmation dialog
        
        # use random user to fill in blanks
        a = @lan.attendances.first
        msg = @parsed_message
        msg = msg.gsub("$DAYS_PARTICIPATED", a.days_participated.to_s)
        msg = msg.gsub("$NAME", a.user.name)
        msg = msg.gsub("$FEE",  a.fee.to_s)
        @parsed_message = msg.html_safe

        if msg.include? '$'
          (@errors ||= []) << "Found unparsed dollar sign! This usually indicates that some variable couldn't be found."
        end

        @recipient_count = @lan.attendances.select{ |a| not a.paid and a.fee > 0 }.count

        render 'confirm_sending_invoices'
      else
        # really send email

        @lan.attendances.each do |a|
          if not a.paid and a.fee > 0
            mu = Mailinglist.new
            mu.name  = a.user.name
            mu.email = a.user.email

            msg = @parsed_message
            msg = msg.gsub("$DAYS_PARTICIPATED", a.days_participated.to_s)
            msg = msg.gsub("$NAME", a.user.name)
            msg = msg.gsub("$FEE",  a.fee.to_s)

            LanMailer.enqueue_general_mail_to_user(mu, @subject, msg, true)
          end

        end

        LanMailer.start_processing

        #@message = @message.gsub('<br>',"\n")
        flash[:notice] = "gesendet"
      end
    elsif params[:edit].nil?
      @subject = '[LAN] Rechnung für Lan vom '+@lan.time
      @message = render_to_string :partial => 'invoice_template'
    end
  end
end
