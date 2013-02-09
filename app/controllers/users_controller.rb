#!/bin/env ruby
#encoding: utf-8

class UsersController < ApplicationController
  protect_from_forgery

  before_filter :authenticate, :only => [:edit, :update]

  def index
    @users = User.all
  end

  def attending
	  if Lan.current
		  @users = Lan.current.users
	  else
		  @users = []
	  end

	  render :action => 'index'
  end

  def show
    @user = User.find_by_id(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.signup_registered(User.new(params[:user]))
    if @user.errors.empty? and @user.save
      session[:user_id] = @user.id
      redirect_to root_url
    else
      render "new"
    end
  end

  def edit
	  @user = User.find(params[:id])
	  authenticate_specific_user(@user)
  end

  def update
	  @user = User.find(params[:id])
	  authenticate_specific_user(@user)

	  if @user.update_attributes(params[:user])
		  redirect_to(@user, :notice => 'Änderungen wurden gespeichert')
	  else
		  render :action => 'edit'
	  end
  end
end
