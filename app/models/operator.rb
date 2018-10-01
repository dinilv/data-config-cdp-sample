class Operator
  require 'autoinc'
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Autoinc

  field :operator_id, type: Integer
  field :operator_name, type: String
  field :operator_key, type: String
  field :operator_country, type: Integer
  field :status, type: Integer, default: 1

  increments :operator_id, seed: 100
  index({ operator_name: 1, operator_id: 1 }, { unique: true, name: "operators" })
end
