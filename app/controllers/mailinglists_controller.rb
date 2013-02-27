#!/bin/env ruby
# encoding: UTF-8

class MailinglistsController < ApplicationController
  protect_from_forgery

  layout 'lan'

  before_filter :authenticate_admin, :except => [:new, :create, :destroy, :confirm_delete]

  def new
    @mailinglist_entry = Mailinglist.new
  end

  def create
    @mailinglist_entry = Mailinglist.new(params[:mailinglist])

    if @mailinglist_entry.save
      redirect_to(new_mailinglist_path, :notice => 'Eintrag gespeichert')
    else
      @errors = @mailinglist_entry.errors.full_messages
      render :action => 'new'
    end
  end

  def manage
    @entries = Mailinglist.all
  end

  def import
    @separator = ','
  end

  def receive_import
    @separator = params[:separator].strip
    @data      = params[:data]
    @values    = @data.split(/\r?\n/).map{|x| x.split(@separator)}
    
    @count_ok = 0
    @count_failed = 0
    @data = ''
    @errors = []

    @values.each do |v|
      name = v[0].strip
      mail = v[1].strip
      e = Mailinglist.new(:name => name, :email => mail)
      if e.save
        @count_ok += 1
      else
        @count_failed += 1
        @data += "#{name}#{@separator}#{mail}\n"
        @errors += e.errors.full_messages
      end
    end

    flash[:notice] = "#{@count_ok} Einträge gespeichert<br>#{@count_failed} fehlgeschlagen".html_safe
    render :action => 'import'
  end

  def send_message
    @recipient_count = Mailinglist.count
    if Lan.current
      @registered_count = Lan.current.users.count
      @recipient_count_without_registered = Mailinglist.all_without_registered.count
    else
      @registered_count = 0
      @recipient_count_without_registered = @recipient_count
    end

    @message = params[:message]
    @subject = params[:subject]

    if !@message.blank? and !@subject.blank?
      # TODO: implement this in seperate thread (done: via rake) and provide some sort of live-updates
      msg = @message.gsub(/\r?\n/,'<br>').html_safe

      if params[:recipient_group] == :list_whithout_registered
        Mailinglist.send_to_all(@subject, msg, true)
      elsif params[:recipient_group] == :only_registered
        Mailinglist.send_to_registered(@subject, msg)
      else
        Mailinglist.send_to_all(@subject, msg, false)
      end

      flash[:notice] = "gesendet"
    else
      @lan = Lan.current
      if @lan
        @subject = '[LAN] Einladung für '+@lan.time
        @message = render_to_string :partial => 'new_template'
      else
        @subject = '[LAN] Einladung für KEINE AKTUELLE LAN'
        @message = 'Es ist keine LAN als aktuell markiert. Du kannst dies unter [link to lan management] ändern.'
      end
    end
  end


  def confirm_delete
    @entry = Mailinglist.find_by_email(params[:email])

    if @entry.nil?
      redirect_to(new_mailinglist_path, :notice => 'EMail-Adresse existiert nicht')
    end
  end

  def destroy
    @entry = Mailinglist.find(params[:id])

    if !@entry.nil?
      @entry.delete
      redirect_to(new_mailinglist_path, :notice => 'Eintrag gelöscht')
    else
      redirect_to(new_mailinglist_path, :notice => 'EMail-Adresse existiert nicht')
    end
  end
end
