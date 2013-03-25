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

    if !@message.blank? and !@subject.blank?
      @message = @message
        .gsub("$TOTAL_COSTS", @lan.total_costs.to_s)
        .gsub("$TOTAL_DAYS",  @lan.total_days.to_s)
        .gsub("$COST_PER_DAY", (@lan.total_costs / @lan.total_days).to_s )
        .gsub(/\r?\n/,'<br>').html_safe

    @lan.attendances.each do |a|
      if not a.paid and a.fee > 0
        mu = Mailinglist.new
        mu.name  = a.user.name
        mu.email = a.user.email

        msg = @message.gsub("$NAME", a.user.name)
        msg = @message.gsub("$FEE",  a.fee)

        LanMailer.enqueue_general_mail_to_user(mu, @subject, msg)
      end
    end

      flash[:notice] = "gesendet"
  else
    @subject = '[LAN] Rechnung für Lan vom '+@lan.time
    @message = render_to_string :partial => 'invoice_template'
  end
  end
end
