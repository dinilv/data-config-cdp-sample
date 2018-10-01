class Media
  require 'autoinc'

  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Autoinc
  
  field :media_id, type: Integer
  field :media_name, type: String
  field :media_template, type: String
  field :status, type: Integer, default: 1
  field :countryIDs, type: Array
  validates :media_id, uniqueness: true
  index({ media_id: 1, media_name: 1 }, { unique: true, name: "medias" })

end
