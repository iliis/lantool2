#!/bin/env ruby
#encoding: utf-8

class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :current_user
  helper_method :admin?
  helper_method :logged_in?

private
  
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def logged_in?
    current_user.present?
  end

  def admin?
    current_user.present? and current_user.admin?
  end

  def authenticate
    if current_user.present?
      true
    else
      session[:return_to] = request.url
      redirect_to(login_path, :notice => "Nur für angemeldete Benutzer.") and return false
    end
  end

  def authenticate_admin
    if authenticate
      if admin?
        true
      else
        redirect_to(root_path, :notice => "Nur für Admins.") and return false
      end
    end
  end

  def authenticate_specific_user(u)
	  if current_user.present? and (current_user.admin? or (u.present? and u == current_user))
		  true
	  else
		  redirect_to(root_path, :notice => "Keine Berechtigung.") and return false
	  end
  end
			  
end
