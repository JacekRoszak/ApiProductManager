class User < ApplicationRecord
  has_secure_password
  acts_as_token_authenticatable

  validates :login, presence: true , uniqueness: true
  validates :password_digest, presence: true

  has_many :orders
end
