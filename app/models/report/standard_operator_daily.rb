class Report::StandardOperatorDaily

  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Attributes::Dynamic

  #mandatory fields for querying
  field :oid,   as: :operator_id, type: String
  field :cid,   as: :campaign_id, type: String
  field :meid,  as: :media_id, type: String
  field :d,     as: :date , type: DateTime
  field :ud,     as: :utc_date , type: DateTime

  #subscription details
  field :usup,   as: :un_subscriptions, type: Integer
  field :asub,   as: :active_subscribers,type: Integer

  field :sup0,   as: :subscriptions_day_0, type: Integer
  field :sup1,   as: :subscriptions_day_1, type: Integer
  field :sup3,   as: :subscriptions_day_3,type: Integer
  field :sup7,   as: :subscriptions_day_7,type: Integer
  field :sup15,  as: :subscriptions_day_15, type: Integer

  field :usup0,  as: :un_subscriptions_day_0, type: Integer
  field :usup1,  as: :un_subscriptions_day_1,type: Integer
  field :usup3,  as: :un_subscriptions_day_3,type: Integer
  field :usup7,  as: :un_subscriptions_day_7,type: Integer
  field :usup15, as: :un_subscriptions_day_15,type: Integer

  field :mts,    as: :mt_sent, type: Integer
  field :mtf,    as: :mt_fail, type: Integer
  field :mtss,   as: :mt_success, type: Integer
  field :mtu,    as: :mt_unknown,type: Integer
  field :mtr,    as: :mt_retry,type: Integer
  field :mtso,   as: :mt_sent_by_operator, type: Integer
  field :mtd,    as: :mt_delivered,type: Integer

  index({  campaign_id: 1, media_id: 1,operator_id: 1, date: 1, utc_date: 1 })

  def self.delete_existing(c_id,me_id,o_id,date)
    where(:cid => c_id, :meid => me_id, :oid=> o_id,:d=> date).delete
  end
  def self.sum_daily(pipelines)
    collection.aggregate(pipelines)
  end
end
