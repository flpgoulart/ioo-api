class Api::V3::UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :auth_token, :created_at, :updated_at, :user_type

end
