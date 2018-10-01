class Report::StandardMediaDaily

  include Mongoid::Document
  include Mongoid::Timestamps

  #mandatory fields for querying
  field :cid,   as: :campaign_id, type: String
  field :meid,  as: :media_id, type: String
  field :d,     as: :date , type: DateTime
  field :ud,    as: :utc_date , type: DateTime

  # media stats
  field :i,      as: :impressions,  type: Integer
  field :di,     as: :duplicate_impressions, type: Integer
  field :ui,     as: :unique_impressions, type: Integer
  field :ii,     as: :invalid_impressions, type: Integer
  field :vi,     as: :valid_impressions, type: Integer

  field :bc,     as: :banner_clicks, type: Integer
  field :dbc,    as: :duplicate_banner_clicks, type: Integer
  field :ubc,    as: :unique_banner_clicks,type: Integer
  field :ibc,    as: :invalid_banner_clicks,type: Integer
  field :vbc,    as: :valid_banner_clicks,type: Integer

  field :lpv,    as: :landing_page_views, type: Integer
  field :dlpv,   as: :duplicate_landing_page_views, type: Integer
  field :ulpv,   as: :unique_landing_page_views, type: Integer
  field :ilpv,   as: :invalid_landing_page_views, type: Integer
  field :vlpv,   as: :valid_landing_page_views, type: Integer

  field :e,      as: :engagments, type: Integer
  field :de,     as: :duplicate_engagments, type: Integer
  field :ue,     as: :unique_engagments, type: Integer
  field :ie,     as: :invalid_engagments, type: Integer
  field :ve,     as: :valid_engagments, type: Integer

  field :sup,    as: :subscriptions, type: Integer
  field :vsup,   as: :valid_subscriptions, type: Integer
  field :isup,   as: :invalid_subscriptions, type: Integer

  field :cv,     as: :content_views, type: Integer
  field :mp,     as: :media_postbacks, type: Integer
  field :sp,     as: :subscription_postbacks, type: Integer

  index({  campaign_id: 1, media_id: 1, date: 1 ,utc_date: 1})

  def self.delete_existing(c_id,me_id,date)
    where(:cid => c_id, :meid => me_id , :d => date).delete
  end

  def self.sum_daily(pipelines)
    collection.aggregate(pipelines)
  end
end
