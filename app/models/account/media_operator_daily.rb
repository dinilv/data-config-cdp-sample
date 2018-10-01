class Account::MediaOperatorDaily

include Mongoid::Document
include Mongoid::Timestamps

#ids
field :cyid, as: :company_id, type: String
field :meid, as: :media_id, type: String
field :d,    as: :date , type: DateTime

#meta config
field :cui,   as: :currency_id, type: Integer
field :cu,    as: :currency, type: String
field :ex,    as: :exchange, type: Float
field :tz,    as: :timezone_id, type: Integer
  field :coid,  as: :country_id, type: Integer

#media
field :mn,     as: :media_name, type: String

#meta data
field :lo,    as: :live_operators, type: String
field :lm,    as: :live_media, type: String
field :loc,   as: :live_operator_count, type: Integer
field :lmc,   as: :live_media_count, type: Integer

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
field :vsup,   as: :valid_subscriptions, type: Number
field :isup,   as: :invalid_subscriptions, type: Number

field :cv,     as: :content_views, type: Number
field :mp,     as: :media_postbacks, type: Number
field :sp,     as: :subscription_postbacks, type: Number

# finance fields
  field :mdcd,   as: :media_cost_dollar,type: Dollar
  field :mdcl,   as: :media_cost_local,type: Amount

# deduced fields
  field :vcp,    as: :valid_click_percent, type: Percentage
  field :srp,    as: :sub_rate_percent, type: Percentage
  field :vsp,    as: :valid_sub_percent,type: Percentage
  field :up,     as: :unsub_percent, type: Percentage
  field :vep,    as: :valid_engagment_percent,type: Percentage
  field :lpvp,   as: :landing_page_valid_percent,type: Percentage

  embeds_many :or, as: :operator_report, class_name: "MediaOperatorDaily"
end