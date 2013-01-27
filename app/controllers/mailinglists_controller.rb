#!/bin/env ruby
# encoding: UTF-8

class MailinglistsController < ApplicationController
  protect_from_forgery

  layout 'lan'

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
    @separator = params[:separator]
    @data      = params[:data]
    @values    = @data.split('\n').split(@seperator)
    
    
    @separator = ','
  end

  def send_message
	  @recipient_count = Mailinglists.count
	  @message = 'default message template' # use a partial view or something here
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
