class Campaign::OperatorDaily

  include Mongoid::Document
  include Mongoid::Timestamps


  #ids
  field :cyid,  as: :company_id, type: String
  field :cid,   as: :campaign_id, type: String
  field :oid ,  as: :operator_id, type: String
  field :d,     as: :date , type: DateTime

  #meta config
  field :z,    as: :zero_data_tag, type: Boolean, default: false
  field :cui,  as: :currency_id, type: Integer
  field :cu,   as: :currency, type: String
  field :ex,   as: :exchange, type: Float
  field :tz,   as: :timezone_id, type: Integer
  field :coid,  as: :country_id, type: Integer

  # operator
  field :on,    as: :operator_name, type: String

  #campaign details
  field :cn,   as: :campaign_name, type: String
  field :dt,   as: :mt_daily_approved, type: Integer
  field :sc,   as: :service_code, type: String
  field :am,   as: :acquisition_model,type: String
  field :c,    as: :country ,type: String
  field :lp,   as: :landing_page ,type: String
  field :ky,   as: :keyword, type: String

  #meta data
  field :lo,    as: :live_operators, type: String
  field :lm,    as: :live_media, type: String
  field :loc,   as: :live_operator_count, type: Integer
  field :lmc,   as: :live_media_count, type: Integer

  #custom datatype in config
  field :gs,    as: :gateway_share, type: Percentage
  field :ops,   as: :operator_share, type: Percentage
  field :ucd,   as: :unit_charge_dollar, type: Dollar
  field :ncd,   as: :net_charge_dollar, type: Dollar
  field :ucl,   as: :unit_charge_local, type: Amount
  field :ncl,   as: :net_charge_local, type: Amount

  #for graph
  field :gid,   as: :graph_id, type: String
  field :wy,    as: :week_of_year, type: Integer
  field :m,     as: :month, type: String
  field :mid,   as: :month_id, type: Integer
  field :y,     as: :year, type: Integer
  field :dy,    as: :day_of_year, type: Integer

  #subscriptions
  field :sup,    as: :subscriptions, type: Number
  field :usup,   as: :un_subscriptions, type: Number

  field :cv,     as: :content_views, type: Number
  field :mp,     as: :media_postbacks, type: Number
  field :sp,     as: :subscription_postbacks, type: Number

  # subscription details
  field :sub,    as: :subscribers,type: Number
  field :asub,   as: :active_subscribers,type: Number

  field :sup0,   as: :subscriptions_day_0, type: Number
  field :sup1,   as: :subscriptions_day_1, type: Number
  field :sup3,   as: :subscriptions_day_3,type: Number
  field :sup7,   as: :subscriptions_day_7,type: Number
  field :sup15,  as: :subscriptions_day_15, type: Number

  field :usup0,  as: :un_subscriptions_day_0, type: Number
  field :usup1,  as: :un_subscriptions_day_1,type: Number
  field :usup3,  as: :un_subscriptions_day_3,type: Number
  field :usup7,  as: :un_subscriptions_day_7,type: Number
  field :usup15, as: :un_subscriptions_day_15,type: Number

  field :mts,    as: :mt_sent, type: Number
  field :mtf,    as: :mt_fail, type: Number
  field :mtss,   as: :mt_success, type: Number
  field :mtu,    as: :mt_unknown,type: Number
  field :mtr,    as: :mt_retry,type: Number
  field :mtso,   as: :mt_sent_by_operator, type: Number
  field :mtd,    as: :mt_delivered,type: Number

  #finance fields
  field :rd,     as: :revenue_dollar,type: Dollar
  field :rl,     as: :revenue_local,type: Amount
  field :nrd,    as: :net_revenue_dollar,type: Dollar
  field :nrl,    as: :net_revenue_local,type: Amount
  field :arpsd,  as: :average_revenue_per_subscriber_dollar, type: Dollar
  field :arpsl,  as: :average_revenue_per_subscriber_local, type: Amount

  #analysed fields
  field :proid,  as: :pause_roi_dollar, type: Dollar
  field :proil,  as: :pause_roi_local, type: Amount
  field :droid,  as: :daily_roi_dollar, type: Dollar
  field :droil,  as: :daily_roi_local, type: Amount

  # deduced fields
  field :cvp,    as: :content_view_percent, type: Percentage
  field :nsup,   as: :new_sub_unsub_percent, type: Percentage
  field :up,     as: :unsub_percent, type: Percentage
  field :mssp,   as: :mt_success_percent,type: Percentage
  field :mtsp,   as: :mt_sent_percent,type: Percentage

  index(company_id: 1,content_provider_id:1,campaign_id: 1, operator_id: 1, date: 1,zero_data_tag: 1  )

  def self.find_sub_by_cid_and_op_and_date(cy_id,c_id,op_id,date)
    where(:cy_id => cy_id ,:cid => c_id, :oid=> op_id ,:d => {
        "$lte" => date}).only("subscribers").limit(1).desc("d")
  end

  def self.delete_existing(cy_id,c_id,o_id,date)
    where(:cyid => cy_id,:cid => c_id, :oid=> o_id,:d=> date).delete
  end

  def self.sum_daily(pipelines)
    collection.aggregate(pipelines)
  end

  def self.find_by_campaign_and_operator_and_date(c_id,o_id,date)
    find_by( :cid=>c_id,:oid=> o_id,:d => date)
  end


end
