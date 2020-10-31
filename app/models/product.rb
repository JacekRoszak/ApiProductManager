class Product < ApplicationRecord
  validates :quantity, presence: true, numericality: { greater_than: 0 }
  validates :code, presence: true, uniqueness: true
  validates :name, presence: true, uniqueness: true

  # has_many :orders, class_name: 'Order', foreign_key: 'code'

end
