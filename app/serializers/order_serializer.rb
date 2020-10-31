class OrderSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :code, :quantity
end
