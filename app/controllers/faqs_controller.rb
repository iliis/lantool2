class FaqsController < ApplicationController
  protect_from_forgery

  layout 'lan'

  def index
    @faqs = Faq.all
  end

  def new
    @faq = Faq.new
  end

  def create
    @faq = Faq.new(params[:faq])

    if @faq.save
      flash[:notice] = 'gespeichert'
      @faq = nil
    else
      @errors = @faq.errors.full_messages
    end

    render :action => 'new'
  end

end
