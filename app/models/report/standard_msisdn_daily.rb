class Report::StandardMsisdnDaily

  include Mongoid::Document
  include Mongoid::Timestamps

  field :cid,     as: :campaign_id, type: String
  field :meid,    as: :media_id, type: String
  field :oid,     as: :operator_id, type: String
  field :msid,    as: :msisdn, type: String
  field :d,       as: :date , type: DateTime

  # subscription details
  field :mts,    as: :mt_sent, type: Integer
  field :mtf,    as: :mt_fail, type: Integer
  field :mtss,   as: :mt_success, type: Integer
  field :mtu,    as: :mt_unknown,type: Integer
  field :mtr,    as: :mt_retry,type: Integer
  field :mtso,   as: :mt_sent_by_operator, type: Integer
  field :mtd,    as: :mt_delivered,type: Integer
  field :sup,    as: :subscriptions, type: Integer
  field :usup,   as: :un_subscriptions, type: Integer

  index(campaign_id: 1, media_id: 1,operator_id:1,msisdn: 1,date: 1  )

  def self.sum_daily(pipelines)
    collection.aggregate(pipelines)
  end

end