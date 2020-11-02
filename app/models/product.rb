class Product < ApplicationRecord
  validates :quantity, presence: true, numericality: { greater_than: 0 }
  validates :code, presence: true, uniqueness: true
  validates :name, presence: true, uniqueness: true
end
