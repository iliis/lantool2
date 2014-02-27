#!/bin/env ruby
#encoding: utf-8

require 'valid_email'

class User < ActiveRecord::Base
  attr_accessible :email, :name, :nick, :password, :password_confirmation
  attr_accessor :password

  before_save :encrypt_password

  has_many :attendances, :dependent => :destroy
  has_many :lans, :through => :attendances
  has_many :polls, :foreign_key => 'owner_id', :dependent => :destroy
  has_many :activities, :dependent => :destroy, :class_name => 'UserActivity'
  has_many :host_activities, :dependent => :destroy, :class_name => 'HostActivity'

  validates :name,  :presence => true,
                    :uniqueness => true
  validates :nick,  :uniqueness => true
  validates :email, :presence => true,
                    :email => true,
                    :uniqueness => true

  validates :password, :confirmation => true
  # a new user is created on registration for LAN without password!
  #validates :password, :presence => true, :on => :create

  def attends?(lan)
    lan.users.exists?(self) || lan.users.where(:name => self.name).any? || lan.users.where(:email => self.email).any?
  end

  def admin?
    self.admin.present? and self.admin == true
  end

  def first_name
    name.split(' ').first
  end

  # some syntactic sugar
  def self.current
    # this is only available in Controller::Base!
    # todo: fix this
    current_user
  end

  def has_voted_on?(poll)
    poll.has_vote_from?(self)
  end

  def encrypt_password
    if password.present?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
    end
  end

  def self.authenticate(name_email, password)
    user   = find_by_email(name_email)
    user ||= find_by_name(name_email)
    user ||= find_by_nick(name_email)
    if user and user.password_hash and user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
      return user
    else
      return nil
    end
  end

  # after registration a user only has name, email and nick => for login, a password has to be set
  # def self.signup_registered(tmp_user)
  
  # after registration, no user exists => create a new one (or return one from a previous lan)
  def self.create_from_registration(tmp_user)
    attendance = Lan.current.attendances.find_by_user_email(tmp_user.email)

    if attendance.nil?
      tmp_user.errors[:email] << "Nicht gefunden. Hast du dich für diese LAN angemeldet?"
      return tmp_user
    end

    if attendance.user.nil?
      # try to find existing one (e.g. from a previous LAN)
      u = User.find_by_email(attendance.user_email)
      if u.nil?
        u = User.new
        u.name  = attendance.user_name
        u.nick  = attendance.user_nick
        u.email = attendance.user_email
      end
      # attendance.user has to be set to u
      # but this works only if u is actually saved in database first
      # so we have to do this in the controller (UsersController::create)
    else
      # reuse existing (this happens if user already signed up)
      u = attendance.user
    end

    if u.password_hash.nil?
      u.password              = tmp_user.password
      u.password_confirmation = tmp_user.password_confirmation
      return u
    else
      tmp_user.errors[:base] << "Es wurde bereits ein Passwort gesetzt. Melde dich beim Admin falls du dein Passwort vergessen hast."
      return tmp_user
    end
  end

  def update_activity(ip)
    UserActivity.update(self, ip)
  end

  def current_ip
    activity = HostActivity.where(:user_id => self)
    if activity.nil? || activity.first.nil? || activity.first.ip.blank?
      return "unbekannt"
    else
      return activity.first.ip
    end
  end

  def current_hostname
    activity = HostActivity.where(:user_id => self)
    if activity.nil? || activity.first.nil? || activity.first.hostname.blank?
      return "unbekannt"
    else
      return activity.first.hostname
    end
  end

  def current_ports
    activity = HostActivity.where(:user_id => self)
    if activity.nil? || activity.first.nil? || activity.first.ports.blank?
      return "unbekannt"
    else
      return activity.first.ports
    end
  end
end
