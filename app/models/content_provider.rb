class ContentProvider
  require 'autoinc'

  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Autoinc

  has_many :campaigns, dependent: :destroy, class_name: "Campaign", autosave: true
  field :content_provider_id, type: Integer
  field :company_id, type: Integer
  field :first_name, type: String
  field :last_name, type: String
  field :email, type: String
  field :contact, type: String
  field :address, type: String
  field :country_id, type: Integer
  field :timezone_id, type: Integer
  field :currency_id, type: Integer
  field :company_name, type: String
  field :company_billing_address, type: String
  field :company_registered_address, type: String
  field :company_tax_number, type: String
  field :language_id, type: Integer
  field :plan, type: Integer
  field :keys, type: String
  field :card_details, type: String
  field :api_limit, type: Integer
  field :click_limit, type: Integer
  field :subscription_start_date, type: DateTime, default: Date.today()
  field :subscription_day_left, type: Integer, default: 14
  field :subscription_type, type: Integer, default: 1
  field :status,type: Integer,default: 1
  embeds_many :content_provider_history, as: :content_provider_history, class_name: "Event"

  validates_presence_of :email, :first_name
  increments :content_provider_id, seed: 10000
  validates :email, uniqueness: true
  index({name: 1, content_provider_id: 1}, {unique: true, name: "content_provider"})

  def self.listing(search, offset, limit, sort, order)
     where("$or" => [{"content_provider_id" => search}, {"first_name" => search},
                                       {"country_id" => search}]).
        only(["content_provider_id", "first_name", "country_id", "email","company_id"]).
        skip(offset).limit(limit).order_by(sort => order)
  end

  def self.content_provider_count(search)
    where("$or" => [{"content_provider_id" => search},
                    {"first_name" => search},
                    {"country_id" => search}]).count
  end
end
