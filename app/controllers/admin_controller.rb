class AdminController < ApplicationController
  before_filter :authenticate_admin

  def index
  end

  def manage_attendances
    if Lan.current
      @attendances = Lan.current.attendances
    else
      redirect_to :action => :index, :notice => 'Keine Lan als aktuell markiert'
    end
  end

  def update_attendances
    @attendances = Attendance.update(params[:attendances].keys, params[:attendances].values).reject { |a| a.errors.empty? }
    if @attendances.empty?
      redirect_to :action => :manage_attendances
    else
      render :action => :manage_attendances
    end
  end
end
