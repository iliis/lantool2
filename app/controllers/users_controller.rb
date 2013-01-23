class UsersController < ApplicationController
  protect_from_forgery

  def index
    @users = User.all
  end

  def show
    @user = User.find_by_id(params[:id])
  end
end
