#!/bin/env ruby
#encoding: utf-8

class PollsController < ApplicationController
  protect_from_forgery

  before_filter :authenticate, :except => [:index, :show]

  def index
    @polls = Lan.current.polls
  end

  def show
    @poll = Poll.find(params[:id])
  end
  
  def vote
    @poll = Poll.find(params[:id])

    show_poll_if_expired(@poll)
    redirect_to(poll_path(@poll)) if current_user.has_voted_on?(@poll)

    # todo: pull out vote of current user (if any)
    # @vote = @poll.
    @vote = PollVote.new
  end

  def receive_vote
    @poll = Poll.find(params[:id])
    show_poll_if_expired(@poll)
    
    if @poll.vote!(params[:vote], current_user)
      redirect_to(poll_path(@poll), :notice => 'Dine Stimme wurde gezählt.')
    else
      redirect_to(vote_poll_path(@poll), :notice => 'Da ist was schiefgelaufen. Versuchs nochmal.')
    end
  end

  def new
    @poll = Poll.new
  end

  def create
    @poll = Poll.new(params[:poll])

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

  def show_poll_if_expired(poll)
    redirect_to(poll_path(poll), :notice => 'diese Abstimmung ist abgelaufen') if poll.expired?
  end
end