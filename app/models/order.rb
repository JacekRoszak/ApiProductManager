class Order < ApplicationRecord
  validates :user_id, presence: true
  validates :code, presence: true
  validates :quantity, presence: true, numericality: { greater_than: 0 }

  belongs_to :user
  belongs_to :product, class_name: 'Product', foreign_key: 'code'
end
