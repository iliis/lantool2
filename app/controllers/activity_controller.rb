class ActivityController < ApplicationController
  before_filter :authenticate_admin

  def plot
    if Lan.current
      @users = Lan.current.users
      @starttime = Lan.current.starttime
      @endtime   = Lan.current.endtime
    else
      @users = []
    end
  end
end
