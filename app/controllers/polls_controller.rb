#!/bin/env ruby
#encoding: utf-8

class PollsController < ApplicationController
  protect_from_forgery

  before_filter :authenticate, :except => [:index, :show]

  def index
    @polls = Lan.current.polls.order("created_at")
  end

  def show
    @poll = Poll.find(params[:id])
  end


# voting
# ////////////////////////////////

  def vote
    @poll = Poll.find(params[:id])

    show_poll(@poll) and return unless @poll.can_be_voted_on_from?(current_user)

    # todo: pull out vote of current user (if any)
    # @vote = @poll.
    @vote = PollVote.new
  end

  def receive_vote
    @poll = Poll.find(params[:id])

    show_poll(@poll) and return unless @poll.can_be_voted_on_from?(current_user)
    
    if @poll.vote(params[:vote], current_user)
      redirect_to(poll_path(@poll), :notice => 'Deine Stimme wurde gezählt.')
    else
      redirect_to(vote_poll_path(@poll), :notice => 'Da ist was schiefgelaufen. Versuchs nochmal.')
    end
  end


# create new poll
# ////////////////////////////////

  # first page of form
  # (maybe move this into new or something)
  def choose_new_type
    @types = Poll.all_types_for_select
  end

  # second page, has to be customized according to type
  # additional form fields are loaded from polls/new_forms/
  def new
    @poll = Poll.class_from_string(params[:type]).new(params[:poll])
  end

  def create
    @poll = new

    @poll.lan = Lan.current
    @poll.owner = current_user

    if @poll.save
      flash[:notice] = 'neue Abstimmung gespeichert'
      redirect_to :action => 'index'
    else
      render :action => 'new'
    end
  end

private

  def show_poll(poll)
    redirect_to(poll_path(poll), :notice => 'kann nicht abstimmen: Zeit abgelaufen / keine Berechtigung / bereits abgestimmt')
  end
end
