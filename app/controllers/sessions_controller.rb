class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.authenticate(params[:name], params[:password])

    if user
      session[:user_id] = user.id
      redirect_to(session[:return_to] || root_url)
      session[:return_to] = nil
    else
      @errors = ["Login fehlgeschlagen"]
      @name   = params[:name]
      render "new"
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url
  end
end
