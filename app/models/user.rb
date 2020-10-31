class User < ApplicationRecord
  validates :login, presence: true, uniqueness: true
  validates :password, presence: true

  has_many :orders
end
