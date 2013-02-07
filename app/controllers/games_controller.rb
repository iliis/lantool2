class GamesController < ApplicationController
  protect_from_forgery

  layout 'lan'

  before_filter :authenticate_admin, :except => [:index]

  def index
    @games = Game.all
  end

  def new
    @game = Game.new
  end

  def create
    @game = Game.new(params[:game])

    if @game.save
      flash[:notice] = 'gespeichert'
      @game = Game.new
    else
      @errors = @game.errors.full_messages
    end

    render :action => 'new'
  end

end
