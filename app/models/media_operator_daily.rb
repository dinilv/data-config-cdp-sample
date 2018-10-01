class MediaOperatorDaily

  include Mongoid::Document
  include Mongoid::Timestamps


  #ids
  field :oid ,  as: :operator_id, type: String

  # operator
  field :on,    as: :operator_name, type: String

  #subscriptions
  #
  field :sup,    as: :subscriptions, type: Number
  field :asub,   as: :active_subscribers,type: Number
  field :usup,   as: :un_subscriptions, type: Number
  field :cv,     as: :content_views, type: Number

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

  index( operator_id: 1  )



end
