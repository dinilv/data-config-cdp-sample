class Event

  include Mongoid::Document
  include Mongoid::Timestamps

  field :id, type: Integer
  field :name, type: String
  field :detail, type: String
  field :ip, type: String


end
