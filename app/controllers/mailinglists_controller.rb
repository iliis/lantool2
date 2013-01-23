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
