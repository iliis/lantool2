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
  def self.signup_registered(tmp_user)
    u = User.find_by_email(tmp_user.email)

    if u
      if u.password_hash.nil?
        u.password              = tmp_user.password
        u.password_confirmation = tmp_user.password_confirmation
        return u
      else
        tmp_user.errors[:base] << "Es wurde bereits ein Passwort gesetzt. Melde dich beim Admin falls du dein Passwort vergessen hast."
        return tmp_user
      end
    else
      tmp_user.errors[:email] << "nicht gefunden. Hast du dich für diese LAN angemeldet?"
      return tmp_user
    end
  end
end
