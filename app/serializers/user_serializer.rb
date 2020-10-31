class UserSerializer < ActiveModel::Serializer
  attributes :id, :login, :password, :admin
end
