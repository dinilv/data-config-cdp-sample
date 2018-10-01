class Company
  require 'autoinc'

  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Autoinc

  has_many :content_providers, dependent: :destroy, class_name: "ContentProvider", autosave: true
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

  validates_presence_of :email
  increments :company_id, seed: 20000
  validates :email, uniqueness: true
  index({ name: 1, company_id: 1 }, { unique: true, name: "company" })

  def self.listing(search, offset, limit, sort, order)
    where("$or" => [{"company_id" => search}, {"email" => search},
                                       {"country_id" => search}]).
        only(["company_id", "email", "status", "country_id", "company_name"]).
        skip(offset).limit(limit).order_by(sort => order)
  end

  def self.company_count(search)
    where("$or" => [{"company_id" => search},
                    {"email" => search},
                    {"company_name" => search}]).count
  end

end
