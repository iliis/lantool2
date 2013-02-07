class AdminController < ApplicationController
  before_filter :authenticate_admin

  def index
  end

  def canvastest
  end
end
