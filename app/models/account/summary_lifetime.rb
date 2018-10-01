class Account::SummaryLifetime

  include Mongoid::Document
  include Mongoid::Timestamps
  # ids
  field :cyid, as: :company_id, type: String
  field :d,    as: :date , type: DateTime

  #meta config
  field :a,    as: :active, type: Boolean, default: true
  field :cui,  as: :currency_id, type: Integer
  field :cu,   as: :currency, type: String
  field :ex,   as: :exchange, type: Float
  field :tz,   as: :timezone_id, type: Integer
  field :coid,  as: :country_id, type: Integer

  # media stats
  field :i,      as: :impressions,  type: Number
  field :di,     as: :duplicate_impressions, type: Number
  field :ui,     as: :unique_impressions, type: Number
  field :ii,     as: :invalid_impressions, type: Number
  field :vi,     as: :valid_impressions, type: Number

  field :bc,     as: :banner_clicks, type: Number
  field :dbc,    as: :duplicate_banner_clicks, type: Number
  field :ubc,    as: :unique_banner_clicks,type: Number
  field :ibc,    as: :invalid_banner_clicks,type: Number
  field :vbc,    as: :valid_banner_clicks,type: Number

  field :lpv,    as: :landing_page_views, type: Number
  field :dlpv,   as: :duplicate_landing_page_views, type: Number
  field :ulpv,   as: :unique_landing_page_views, type: Number
  field :ilpv,   as: :invalid_landing_page_views, type: Number
  field :vlpv,   as: :valid_landing_page_views, type: Number

  field :e,      as: :engagments, type: Number
  field :de,     as: :duplicate_engagments, type: Number
  field :ue,     as: :unique_engagments, type: Number
  field :ie,     as: :invalid_engagments, type: Number
  field :ve,     as: :valid_engagments, type: Number

  field :sup,    as: :subscriptions, type: Number
  field :usup,   as: :un_subscriptions, type: Number
  field :vsup,   as: :valid_subscriptions, type: Number
  field :isup,   as: :invalid_subscriptions, type: Number

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

  # finance fields
  field :mdcd,   as: :media_cost_dollar,type: Dollar
  field :mdcl,   as: :media_cost_local,type: Amount
  field :rd,     as: :revenue_dollar,type: Dollar
  field :rl,     as: :revenue_local,type: Amount
  field :nrd,    as: :net_revenue_dollar,type: Dollar
  field :nrl,    as: :net_revenue_local,type: Amount
  field :cpasd,  as: :cost_per_active_subscriber_dollar,type: Dollar
  field :cpasl,  as: :cost_per_active_subscriber_local,type: Amount
  field :arpsd,  as: :average_revenue_per_subscriber_dollar, type: Dollar
  field :arpsl,  as: :average_revenue_per_subscriber_local, type: Amount

  #analysed fields
  field :proid,  as: :pause_roi_dollar, type: Dollar
  field :proil,  as: :pause_roi_local, type: Amount
  field :droid,  as: :daily_roi_dollar, type: Dollar
  field :droil,  as: :daily_roi_local, type: Amount

  # deduced fields
  field :vcp,    as: :valid_click_percent, type: Percentage
  field :cvp,    as: :content_view_percent, type: Percentage
  field :srp,    as: :sub_rate_percent, type: Percentage
  field :vsp,    as: :valid_sub_percent,type: Percentage
  field :nsup,   as: :new_sub_unsub_percent, type: Percentage
  field :up,     as: :unsub_percent, type: Percentage
  field :vep,    as: :valid_engagment_percent,type: Percentage
  field :lpvp,   as: :landing_page_valid_percent,type: Percentage
  field :mssp,   as: :mt_success_percent,type: Percentage
  field :mtsp,   as: :mt_sent_percent,type: Percentage

  index({ company_id:1, content_provider_id: 1 , date: 1, active:1})

  def self.update_active(cy_id,date)
    where(:d => {
        "$lte" => date},:cyid => cy_id).update_all(:a => false)
  end

  def self.delete_existing(cy_id,date)
    where("cyid" => cy_id, "d" => date).delete
  end

  def self.lifetime(cy_id,date)
    where(:cyid => cy_id,:a=>true,:d => {
        "$lte" => date},).only(["mt_sent","revenue_dollar","revenue_local","media_cost_dollar","live_media_count",
                                               "media_cost_local","net_revenue_dollar","net_revenue_local","updated_at"])
  end

  def self.find_by_cp_and_date(cy_id,date)
    where( :cyid => cy_id, :d => {
        "$lte" => date}).desc("d").first
  end


end
