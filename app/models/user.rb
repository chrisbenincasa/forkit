require 'bcrypt'

class User < ActiveRecord::Base
  has_many :personalRecipeInfo
  has_many :recipes, :through => :personalRecipeInfo
  #has_many :settings
  has_many :authorizations
  attr_accessible :name, :username, :email, :password, :password_confirmation

  attr_accessor :password
  before_save :encrypt_password

  validates_length_of :password, :minimum => 5, :on => :create
  validates_confirmation_of :password, :on => :create
  validates_presence_of :password, :on => :create
  validates_presence_of :email, :on => :create
  validates_presence_of :username, :on => :create
  validates_uniqueness_of :username, :on => :create
  validates_uniqueness_of :email, :on => :create
  validates_format_of :email, 
    :with => /^[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}$/i, 
    :on => :create
  validates_format_of :username, 
    :with => /^[-\w\._@]+$/i, 
    :message => 'Only letters, numbers, or .-@_ are allowed', 
    :on => :create

  def self.authenticate(login, password)
    user = find_by_email(login) || find_by_username(login)
    if user and user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
      user
    else
      nil
    end
  end

  def encrypt_password
    if password.present?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
    end
  end

  def to_param
    username
  end
end
