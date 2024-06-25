class UserSerializer
  include JSONAPI::Serializer
  attributes :id, :email, :name, :role_id
end
