class UserSerializer < ActiveModel::Serializer
  attributes :id, :login, :admin, :authentication_token
end
