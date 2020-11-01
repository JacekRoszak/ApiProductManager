class ProductSerializer < ActiveModel::Serializer
  attributes :name, :quantity, :code
end
