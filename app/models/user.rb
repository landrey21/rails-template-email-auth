require 'digest/md5'

class User < ActiveRecord::Base

  self.table_name = 'user'

  EMAIL_REGEX = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i 
  validates :email, :presence => true, :uniqueness => true, :format => EMAIL_REGEX
  validates :password, :confirmation => true

  #---------------------------------------------------------
  def authenticate(input_password)
    self.password == BCrypt::Engine.hash_secret(input_password, self.salt)
  end

  #---------------------------------------------------------
  def encrypt_password(password_str)
    self.salt = BCrypt::Engine.generate_salt
    self.password = BCrypt::Engine.hash_secret(password_str, self.salt)
  end

  #---------------------------------------------------------
  def email_confirmation_hash(email_str)
    confirmation_salt = self.salt.nil? ? BCrypt::Engine.generate_salt : self.salt
    self.email_confirmation = Digest::MD5.hexdigest(confirmation_salt + email_str)
  end

end
