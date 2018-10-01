class Msisdn::Daily

  include Mongoid::Document
  include Mongoid::Timestamps

  #ids
  field :cyid,    as: :company_id, type: String
  field :cid,     as: :campaign_id, type: String
  field :meid,    as: :media_id, type: String
  field :oid ,    as: :operator_id, type: String
  field :msid,    as: :msisdn, type: String
  field :uid,     as: :user_id, type: String
  field :d,       as: :date , type: DateTime

  #meta config
  field :cui,     as: :currency_id, type: Integer
  field :cu,      as: :currency, type: String
  field :ex,      as: :exchange, type: Float
  field :coid,  as: :country_id, type: Integer

  #campaign
  field :cn,    as: :campaign_name, type: String
  field :sc,    as: :service_code, type: String
  field :am,    as: :acquisition_model,type: String
  field :c,     as: :country ,type: String
  field :lp,    as: :landing_page ,type: String
  field :ky,    as: :keyword, type: String

  #config
  field :gs,    as: :gateway_share, type: Percentage
  field :ops,   as: :operator_share, type: Percentage
  field :ucd,   as: :unit_charge_dollar, type: Dollar
  field :ncd,   as: :net_charge_dollar, type: Dollar
  field :ucl,   as: :unit_charge_local, type: Amount
  field :ncl,   as: :net_charge_local, type: Amount

  #operator
  field :on,    as: :operator_name, type: String

  #media
  field :mn,     as: :media_name, type: String
  field :mpd,    as: :media_payout_dollar , type: Dollar
  field :mpl,    as: :media_payout_local, type: Amount

  # media stats
  field :i,      as: :impressions,  type: Number
  field :bc,     as: :banner_clicks, type: Number
  field :lpv,    as: :landing_page_views, type: Number
  field :e,      as: :engagments, type: Number
  field :sup,    as: :subscriptions, type: Number
  field :usup,   as: :un_subscriptions, type: Number
  field :cv,     as: :content_views, type: Number

  # subscription details
  field :mts,    as: :mt_sent, type: Number
  field :mtf,    as: :mt_fail, type: Number
  field :mtss,   as: :mt_success, type: Number
  field :mtu,    as: :mt_unknown,type: Number
  field :mtr,    as: :mt_retry,type: Number
  field :mtso,   as: :mt_sent_by_operator, type: Number
  field :mtd,    as: :mt_delivered,type: Number

  # finance fields
  field :mdcd,   as: :media_cost_dollar,type: Dollar
  field :mdcl,   as: :media_cost_local,type: Amount
  field :rd,     as: :revenue_dollar,type: Dollar
  field :rl,     as: :revenue_local,type: Amount
  field :nrd,    as: :net_revenue_dollar,type: Dollar
  field :nrl,    as: :net_revenue_local,type: Amount
  field :cpasd,  as: :cost_per_active_subscriber_dollar,type: Dollar
  field :cpasl,  as: :cost_per_active_subscriber_local,type: Amount

  #deduced fields
  field :cvp,    as: :content_view_percent, type: Percentage
  field :mssp,   as: :mt_success_percent,type: Percentage
  field :mtsp,   as: :mt_sent_percent,type: Percentage

  index(cyid:1,cid: 1, meid: 1, d: 1 )

  def self.delete_existing(c_id,me_id,op_id,msisdn,date)
    where(:cid => c_id, :meid => me_id ,:oid=> op_id,:msid=> msisdn,:d => date).delete
  end
  def self.delete_by_date(date)
    where(:d => date).delete
  end
  def self.sum_daily(pipelines)
    collection.aggregate(pipelines)
  end

  def self.find_by_msidn(c_id,me_id,op_id,msisdn,date)
    where( :cid => c_id, :meid => me_id,:oid=> op_id, :msid =>msisdn ,:d => date).desc("d").first
  end

end




