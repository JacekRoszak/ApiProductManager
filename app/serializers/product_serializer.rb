class ProductSerializer < ActiveModel::Serializer
  attributes :id, :name, :quantity, :code
end
