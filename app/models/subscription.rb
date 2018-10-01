class Subscription
  require 'autoinc'
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Autoinc
  has_many :content_providers, dependent: :destroy, class_name: "ContenProviders", autosave: true
end