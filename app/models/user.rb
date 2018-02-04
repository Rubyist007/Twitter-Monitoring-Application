require 'active_record'
require 'bcrypt'

class User < ActiveRecord::Base
  include BCrypt

  validates_presence_of :nickname, :password
  validates_uniqueness_of :nickname
  validates_length_of :nickname, maximum: 30

  has_and_belongs_to_many :tracked_users, uniq: true

  def password
    @password ||= Password.new(password_hash)
  end

  def password=(new_password)
    @password = Password.create(new_password)
    self.password_hash = @password
  end
end
