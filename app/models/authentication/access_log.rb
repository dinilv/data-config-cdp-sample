class Authentication::AccessLog
  require 'autoinc'
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Autoinc

  field :user_id, type: Integer
  field :user_role, type: Integer
  field :user_name, type: String
  field :token, type: String
  field :ip, type: String
  field :country, type: String
  field :status, type: String

  index({ user_id: 1 }, { name: "users" })
end
