class UserSerializer < ActiveModel::Serializer
  attributes :id, :login, :admin
end
