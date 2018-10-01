class Account::OperatorDaily

  include Mongoid::Document
  include Mongoid::Timestamps

  #ids
  field :cyid,  as: :company_id, type: String
  field :oid ,  as: :operator_id, type: String
  field :d,     as: :date , type: DateTime

  #meta config
  field :z,    as: :zero_data_tag, type: Boolean, default: false
  field :cui,  as: :currency_id, type: Integer
  field :cu,      as: :currency, type: String
  field :ex,   as: :exchange, type: Float
  field :tz,   as: :timezone_id, type: Integer
  field :coid,  as: :country_id, type: Integer

  #meta data
  field :lsc,   as: :live_service_count, type: Integer
  field :lcc,   as: :live_campaign_count, type: Integer

  #for graph
  field :gid,   as: :graph_id, type: String
  field :wy,    as: :week_of_year, type: Integer
  field :m,     as: :month, type: String
  field :mid,   as: :month_id, type: Integer
  field :y,     as: :year, type: Integer
  field :dy,    as: :day_of_year, type: Integer

  #operator
  field :on,    as: :operator_name, type: String

  #tracking
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
  field :arpud,  as: :average_revenue_per_subscriber_dollar, type: Dollar
  field :arpul,  as: :average_revenue_per_subscriber_local, type: Amount

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

  index(company_id: 1, campaign_id: 1, operator_id: 1, date: 1,zero_data_tag: 1 )

  def self.delete_existing(cy_id,o_id,date)
    where(:cyid => cy_id, :oid => o_id , :d => date).delete
  end

  def self.sum_daily(pipelines)
    collection.aggregate(pipelines)
  end

  def self.find_by_cp_and_operator_and_date(cy_id,op_id,date)
    find_by( :cyid => cy_id, :oid=>op_id,:d => date)
  end

  def self.find_sub_by_cp_and_op_and_date(cy_id,op_id,date)
    where( :cyid => cy_id, :oid=>op_id,:d => {
        "$lte" => date}).only("subscribers").limit(1).desc("d")
  end

  def self.get_count_operator_monetize(report_request)

    filters={}
    filters["cyid"]=report_request["cyid"]
    date_filter={}
    date_filter["$gte"]=report_request["sdate"]
    date_filter["$lte"]=report_request["edate"]
    filters["d"]=date_filter

    if report_request["opids"].length >0
      filters["oid"]={"$in"=> report_request["opids"]}
    end

    return where(filters).count
  end

  def self.get_operator_monetize_report(report_request)

    filters={}
    filters["cyid"]=report_request["cyid"]
    date_filter={}
    date_filter["$gte"]=report_request["sdate"]
    date_filter["$lte"]=report_request["edate"]
    filters["d"]=date_filter
    if report_request["opids"].length >0
      filters["oid"]={"$in"=> report_request["opids"]}
    end

    where(filters).
        only(["date","operator_name","operator_id","country","live_campaign_count","live_service_count",
              "subscriptions","un_subscriptions",
              "un_subscriptions_day_3","un_subscriptions_day_7","un_subscriptions_day_15","active_subscribers",
              "new_sub_unsub_percent","mt_sent_by_operator","mt_sent_percent","mt_success_percent","revenue_local","revenue_dollar",
              "pause_roi_local","pause_roi_dollar","daily_roi_local",
              "daily_roi_dollar" ])
        .order(report_request["sort"]=>report_request["order"])
        .skip(report_request["offset"]).limit(report_request["limit"])


  end

  def self.get_total_report(report_request)

    filters={}
    filters["cyid"]=report_request["cyid"]
    date_filter={}
    date_filter["$gte"]=report_request["sdate"]
    date_filter["$lte"]=report_request["edate"]
    filters["d"]=date_filter
    if report_request["opids"].length >0
      filters["oid"]={"$in"=> report_request["opids"]}
    end

    filter= { "$match" => filters }

    group={"$group"=> { "_id" => {},
                        "sup"=>{ "$sum"=>"$sup.v"},"usub"=>{ "$sum"=>"$usub.v"},
                        "usup"=>{ "$sum"=>"$usup.v"},"usup3"=>{ "$sum"=>"$usu3.v"},
                        "usup7"=>{ "$sum"=>"$usup7.v"},"usup15"=>{ "$sum"=>"$usup15.v"},
                        "mtso"=>{ "$sum"=>"mtso.v"},
                        "rl"=>{ "$sum"=>"$rl.v"},"rd"=>{ "$sum"=>"$rd.v"}





    }

    }

    results=collection.aggregate([filter,group])
    result={}
    #parse it to proper result format
    if results.count >0
      results.each do |each_data|
        result["sup"]=ActiveSupport::NumberHelper.number_to_delimited(each_data["sup"])
        result["usup"]=ActiveSupport::NumberHelper.number_to_delimited(each_data["usup"])
        result["usup3"]=ActiveSupport::NumberHelper.number_to_delimited(each_data["usup3"])
        result["usup7"]=ActiveSupport::NumberHelper.number_to_delimited(each_data["usup7"])
        result["usup15"]=ActiveSupport::NumberHelper.number_to_delimited(each_data["usup15"])
        result["mtso"]=ActiveSupport::NumberHelper.number_to_delimited(each_data["mtso"])
        result["rl"]= ActiveSupport::NumberHelper.number_to_currency(each_data["rl"],unit: report_request["currency"])
        result["rd"]= ActiveSupport::NumberHelper.number_to_currency(each_data["rd"])
      end
    end
    return result
  end

  def self.get_download_report(report_request)

    filters={}
    filters["cyid"]=report_request["cyid"]
    date_filter={}
    date_filter["$gte"]=report_request["sdate"]
    date_filter["$lte"]=report_request["edate"]
    filters["d"]=date_filter

    if report_request["meids"].length >0
      filters["meid"]={"$in"=> report_request["meids"]}
    end


    filter= { "$match" => filters }

    group={"$group"=> { "_id" => {"d"=>"$d","on"=>"$on","c"=>"$c","lcc"=>"$lcc","lsc"=>"$lsc"},
                        "sup"=>{ "$sum"=>"$sup.v"},"usup"=>{ "$sum"=>"$usup.v"},"usup3"=>{ "$sum"=>"$usup3.v"},"usup7"=>{ "$sum"=>"$usu7.v"},
                        "usup15"=>{ "$sum"=>"$usup15.v"},"asub"=>{ "$sum"=>"$asub.v"},"nsup"=>{ "$sum"=>"$nsup.v"},"mtso"=>{ "$sum"=>"$mtso.v"},"mtsp"=>{ "$sum"=>"$mtsp.v"},"mssp"=>{ "$sum"=>"$mssp.v"},
                        "rl"=>{ "$sum"=>"$rl.v"},"rd"=>{ "$sum"=>"$rd.v"},"proil"=>{ "$sum"=>"$proil.v"},
                        "proid"=>{ "$sum"=>"$proid.v"},"droil"=>{ "$sum"=>"$droil.v"},
                        "droid"=>{ "$sum"=>"$droid.v"}






    }
    }
    sort={"$sort"=> {"_id."+report_request["sort"]=> report_request["order"]} }
    collection.aggregate([filter,group,sort])
  end

  def self.get_csv_total_report(report_request)
    filters={}
    filters["cyid"]=report_request["cyid"]
    date_filter={}
    date_filter["$gte"]=report_request["sdate"]
    date_filter["$lte"]=report_request["edate"]
    filters["d"]=date_filter

    if report_request["meids"].length >0
      filters["meid"]={"$in"=> report_request["meids"]}
    end


    filter= { "$match" => filters }

    group={"$group"=> { "_id" => {},
                        "sup"=>{ "$sum"=>"$sup.v"},"usub"=>{ "$sum"=>"$usub.v"},
                        "usup"=>{ "$sum"=>"$usup.v"},"usup3"=>{ "$sum"=>"$usu3.v"},
                        "usup7"=>{ "$sum"=>"$usup7.v"},"usup15"=>{ "$sum"=>"$usup15.v"},
                        "mtso"=>{ "$sum"=>"mtso.v"},
                        "rl"=>{ "$sum"=>"$rl.v"},"rd"=>{ "$sum"=>"$rd.v"}

    }

    }

    results=collection.aggregate([filter,group])
    result=[]

    #parse it to proper result format
    if results.count >0
      results.each do |each_data|
        result.push("Totals")
        result.push("")
        result.push("")
        result.push("")
        result.push("")
        result.push("")
        result.push(each_data["sup"])
        result.push(each_data["usup"])
        result.push(each_data["usup3"])
        result.push(each_data["usup7"])
        result.push(each_data["usup15"])
        result.push("")
        result.push("")
        result.push(each_data["mtso"])
        result.push("")
        result.push("")
        result.push(each_data["rl"])
        result.push(each_data["rd"])
        result.push("")
        result.push("")
        result.push("")
        result.push("")
      end
    end
    return result
  end
end
