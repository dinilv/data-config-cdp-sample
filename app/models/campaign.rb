class Campaign
  require 'autoinc'

  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Autoinc

  belongs_to :contentprovider, class_name: "ContentProvider", dependent: :nullify, polymorphic: true, :optional => true


  field :content_provider_id, type: Integer
  field :company_id, type: Integer
  field :campaign_id, type: Integer
  field :campaign_name, type: String
  field :country_id, type: Integer
  field :mt_daily_approved, type: Integer
  field :category, type: Integer
  field :acquisition_model, type: Integer
  field :landing_page, type: String
  field :keyword, type: String
  field :service_code, type: String
  field :unit_charge_dollar, type: Float
  field :unit_charge_local, type: Float
  field :net_charge_dollar, type: Float
  field :net_charge_local, type: Float
  field :gateway_share, type: Float
  field :operator_share, type: Float
  field :status, type: Integer, default: 0

  field :created_by, type: String
  field :updated_by, type: String

  #validations
  validates_presence_of :acquisition_model

  index({ campaign_name: 1, campaign_id: 1 , service_code:1 }, { unique: true, name: "campaigns" })
  #relations
  embeds_many :campaign_media, as: :campaign_media, class_name: "CampaignMedia"
  embeds_many :campaign_operator, as: :campaign_operator, class_name: "CampaignOperator"

  #id counters
  increments :campaign_id, seed: 10000


  def self.account_active_operator_count(cp_id)
    where(content_provider_id: cp_id, "campaign_operator.status" => 1).count
  end

  def self.account_active_media_count(cp_id)
    where(content_provider_id: cp_id,"campaign_media.status" => 1).count
  end

  def self.operator_active_count(cp_id,op_id)
    where(content_provider_id: cp_id,status: 1,"campaign_operator.operator_id" =>op_id,"campaign_operator.status" => 1).count
  end

  def self.operator_service_count(cp_id,op_id)
    where(content_provider_id: cp_id,status: 1,"campaign_operator.operator_id" =>op_id,"campaign_operator.status" => 1).distinct(:service_code).count
  end

  def self.media_active_count(cp_id,me_id)
    where(content_provider_id: cp_id,status: 1,"campaign_media.media_id"=> me_id, "campaign_media.status"=> 1).count
  end

  def self.media_service_count(cp_id,me_id)
    where(content_provider_id: cp_id,status: 1,"campaign_media.media_id"=> me_id, "campaign_media.status"=> 1).distinct(:service_code).count
  end

  def self.account_service_count(cp_id)
    where(content_provider_id: cp_id, status: 1).distinct(:service_code).count
  end

  def self.account_active_count(cp_id)
    where(content_provider_id: cp_id, status: 1).count
  end


end
