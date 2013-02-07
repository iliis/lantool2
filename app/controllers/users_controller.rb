#!/bin/env ruby
#encoding: utf-8

class UsersController < ApplicationController
  protect_from_forgery

  def index
    @users = User.all
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
end
