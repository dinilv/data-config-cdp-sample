class Member
  require 'autoinc'

  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Autoinc

  field :member_id, type: Integer
  field :email, type: String
  field :password, type: String
  field :password_salt, type: String
  field :token, type: String
  field :role, type: Integer
  field :verified, type: Boolean, default: false
  field :last_login_ip, type: String
  field :is_first_login, type: Boolean, default: true
  field :status, type: Integer, default: 1

  increments :member_id, seed: 1000
  validates_presence_of :email, :password, :password_salt
  validates :email, uniqueness: true
  index({ email: 1, member_id: 1 }, { unique: true, name: "members" })

  '''
  role
  1 => Admin
  2 => Operator
  3 => Content Provider
  4=>  Company
  '''

end
