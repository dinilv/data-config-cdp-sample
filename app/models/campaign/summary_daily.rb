class Campaign::SummaryDaily

  include Mongoid::Document
  include Mongoid::Timestamps

  # ids
  field :cyid, as: :company_id, type: String
  field :cid,  as: :campaign_id, type: String
  field :d,    as: :date , type: DateTime

  #meta config
  field :z,    as: :zero_data_tag, type: Boolean, default: false
  field :cui,  as: :currency_id, type: Integer
  field :cu,   as: :currency, type: String
  field :ex,   as: :exchange, type: Float
  field :tz,   as: :timezone_id, type: Integer
  field :coid,  as: :country_id, type: Integer

  #campaign details
  field :cn,   as: :campaign_name, type: String
  field :dt,   as: :mt_daily_approved, type: Integer
  field :sc,   as: :service_code, type: String
  field :am,   as: :acquisition_model,type: String
  field :c,    as: :country ,type: String
  field :lp,   as: :landing_page ,type: String
  field :ky,   as: :keyword, type: String

  #custom datatype in config
  field :gs,    as: :gateway_share, type: Percentage
  field :ops,   as: :operator_share, type: Percentage
  field :ucd,   as: :unit_charge_dollar, type: Dollar
  field :ncd,   as: :net_charge_dollar, type: Dollar
  field :ucl,   as: :unit_charge_local, type: Amount
  field :ncl,   as: :net_charge_local, type: Amount

  #meta data
  field :lo,    as: :live_operators, type: String
  field :lm,    as: :live_media, type: String
  field :loc,   as: :live_operator_count, type: Integer
  field :lmc,   as: :live_media_count, type: Integer

  #for graph
  field :gid,   as: :graph_id, type: String
  field :wy,    as: :week_of_year, type: Integer
  field :m,     as: :month, type: String
  field :mid,   as: :month_id, type: Integer
  field :y,     as: :year, type: Integer
  field :dy,    as: :day_of_year, type: Integer

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


  index({  company_id:1 ,campaign_id: 1, content_provider_id: 1, date: 1,zero_data_tag: 1  })

  def self.delete_existing(cy_id,c_id,date)
    where(:cyid => cy_id,:cid => c_id, :d => date).delete
  end

  def self.sum_daily(pipelines)
    collection.aggregate(pipelines)
  end

  def self.find_by_campaign_and_date(cy_id,c_id,date)
    find_by(:cyid => cy_id,:cid=>c_id,:d => date)
  end

  def self.current(cy_id,c_id,date)

    sort={"$sort"=> {"d"=> -1} }

    limit={"$limit"=>1}

    filters= { "$match" => {:cyid => cy_id,:cid => c_id,"d" => {
        "$lte" => date}}
    }

    group={"$group"=> { "_id" => {},
                        "sub"=>{"$sum"=>"$sub.v"},"asub"=>{"$sum"=>"$asub.v"},
                        "lcc"=>{"$sum"=>"$lcc"},"lmc"=>{"$sum"=>"$lmc"},
                        "vep"=>{"$sum"=>"$vep.v"},"vsp"=>{"$sum"=>"$vsp.v"},
                        "mssp"=>{"$sum"=>"$mssp.v"},"rl"=>{"$sum"=>"$rl.v"},
                        "cvp"=>{"$sum"=>"$cvp"},"nsup"=>{"$sum"=>"$nsup.v"}
    }
    }


    collection.aggregate([filters,sort,limit,group])
  end

  def self.graph(cy_id,c_id,start_date,end_date)


    filters= { "$match" => {"d" => {
        "$gte" => start_date,
        "$lte" => end_date},"$or" => [{:cyid => cy_id,:cid => c_id},
                                                                   {:z=> true}]}
    }

    group={"$group"=> { "_id" => {"d"=>"$d","gid"=>"$gid"},
                        "sub"=>{"$sum"=>"$sub.v"},"asub"=>{"$sum"=>"$asub.v"},
                        "usup"=>{"$sum"=>"$usup.v"},"arpsl"=>{"$sum"=>"$arpsl.v"},
                        "vsup"=>{"$sum"=>"$vsup.v"},"nsup"=>{"$sum"=>"$nsup.v"},
                        "mssp"=>{"$sum"=>"$mssp.v"},"rl"=>{"$sum"=>"$rl.v"},
                        "nrl"=>{"$sum"=>"$nrl.v"},"mdcl"=>{"$sum"=>"$mdcl.v"}

    }
    }
    sort={"$sort"=> {"_id.d"=> 1} }

    collection.aggregate([filters,group,sort])

  end

  def self.max_value_graph(cy_id,c_id,start_date,end_date)

    filters= { "$match" => {:cyid => cy_id,:cid => c_id,"d" => {
        "$gte" => start_date,
        "$lte" => end_date}}
    }

    group={"$group"=> { "_id" => {},
                        "msub"=> {"$max"=>"$sub.v"},"masub"=> {"$max"=>"$asub.v"},
                        "musup"=> {"$max"=>"$usup.v"},"marpsl"=> {"$max"=>"$arpsl.v"},
                        "mvsup"=> {"$max"=>"$vsup.v"},"mnsup"=>{"$max"=>"$nsup.v"},
                        "mmssp"=> {"$max"=>"$mssp.v"},"mrl"=> {"$max"=>"$rl.v"},
                        "mnrl"=> {"$max"=>"$nrl.v"},"mmdcl"=>{"$max"=>"$mdcl.v"}
    }
    }
    collection.aggregate([filters,group])
  end

  def self.track_graph(cy_id,c_id,start_date,end_date)

    filters= { "$match" => {"d" => {
        "$gte" => start_date,
        "$lte" => end_date},"$or" => [{:cyid => cy_id,:cid => c_id},
                                      {:z=> true}]}
    }

    group={"$group"=> { "_id" => {"d"=>"$d","gid"=>"$gid"},
                        "sub"=>{"$sum"=>"$sub.v"},"asub"=>{"$sum"=>"$asub.v"},
                        "usup"=>{"$sum"=>"$usup.v"},"arpsl"=>{"$sum"=>"$arpsl.v"},
                        "vsup"=>{"$sum"=>"$vsup.v"},"nsup"=>{"$sum"=>"$nsup.v"},
                        "mssp"=>{"$sum"=>"$mssp.v"},"rl"=>{"$sum"=>"$rl.v"},
                        "nrl"=>{"$sum"=>"$nrl.v"},"mdcl"=>{"$sum"=>"$mdcl.v"},
                        "lpv"=>{"$sum"=>"$lpv.v"},"e"=>{"$sum"=>"$e.v"},
                        "bc"=>{"$sum"=>"$bc.v"},"ilpv"=>{"$sum"=>"$ilpv.v"},
                        "ie"=>{"$sum"=>"$ie.v"},"isup"=>{"$sum"=>"$isup.v"},
                        "mts"=>{"$sum"=>"$mts.v"},"mtss"=>{"$sum"=>"$mtss.v"},
                        "mtso"=>{"$sum"=>"mtso.v"}

    }
    }
    sort={"$sort"=> {"_id.d"=> 1} }

    collection.aggregate([filters,group,sort])

  end

  def self.max_value_track_graph(cy_id,c_id,start_date,end_date)

    filters= { "$match" => {:cyid => cy_id,:cid => c_id,"d" => {
        "$gte" => start_date,
        "$lte" => end_date}}
    }

    group={"$group"=> { "_id" => {},
                        "msub"=>{"$max"=>"$sub.v"},"masub"=>{"$max"=>"$asub.v"},
                        "musup"=>{"$max"=>"$usup.v"},"marpsl"=>{"$max"=>"$arpsl.v"},
                        "mvsup"=>{"$max"=>"$vsup.v"},"mrl"=>{"$max"=>"$rl.v"},
                        "mnrl"=>{"$max"=>"$nrl.v"},"mmdcl"=>{"$max"=>"$mdcl.v"},
                        "mlpv"=>{"$max"=>"$lpv.v"},"me"=>{"$max"=>"$e.v"},"mibc"=>{"$max"=>"$ibc.v"},
                        "mbc"=>{"$max"=>"$bc.v"},"milpv"=>{"$max"=>"$ilpv.v"},
                        "mie"=>{"$max"=>"$ie.v"},"misup"=>{"$max"=>"$isup.v"},
                        "mms"=>{"$max"=>"$mts.v"},"mmss"=>{"$max"=>"$mtss.v"},
                        "mmso"=>{"$max"=>"mtso.v"}

    }
    }

    collection.aggregate([filters,group])

  end

  def self.get_count_campaign_monetize(report_request)

    filters={}
    filters["cyid"]=report_request["cyid"]
    date_filter={}
    date_filter["$gte"]=report_request["sdate"]
    date_filter["$lte"]=report_request["edate"]
    filters["d"]=date_filter
    if report_request["cids"].length >0
      filters["cid"]={"$in"=> report_request["cids"]}
    end

    return where(filters).count
  end

  def self.get_campaign_monetize_report(report_request)

    filters={}
    filters["cyid"]=report_request["cyid"]
    date_filter={}
    date_filter["$gte"]=report_request["sdate"]
    date_filter["$lte"]=report_request["edate"]
    filters["d"]=date_filter
    if report_request["cids"].length >0
      filters["cid"]={"$in"=> report_request["cids"]}
    end

    where(filters).
          only(["date","campaign_name","campaign_id","service_code","acquisition_model","live_operator_count",
                "live_media_count","unit_charge_local","unit_charge_dollar","subscriptions","un_subscriptions",
                "un_subscriptions_day_3","un_subscriptions_day_7","un_subscriptions_day_15","active_subscribers",
                "new_sub_unsub_percent","mt_sent_percent","mt_success_percent","revenue_local","revenue_dollar",
                "average_revenue_per_subscriber_local","average_revenue_per_subscriber_dollar","cost_per_active_subscriber_local",
                "cost_per_active_subscriber_dollar","pause_roi_local","pause_roi_dollar","daily_roi_local","daily_roi_dollar"])
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
    if report_request["cids"].length >0
      filters["cid"]={"$in"=> report_request["cids"]}
    end

    filter= { "$match" => filters }

    group={"$group"=> { "_id" => {},
                        "sup"=>{ "$sum"=>"$sup.v"},"usub"=>{ "$sum"=>"$usup.v"},"usup3"=>{ "$sum"=>"usup3.v"},
                        "usup7"=>{ "$sum"=>"$usup7.v"},"usup15"=>{ "$sum"=>"$usup15.v"},"rl"=>{ "$sum"=>"$rl.v"},"rd"=>{ "$sum"=>"$rd.v"}
    }
    }

    results=collection.aggregate([filter,group])
    result={}
    #parse it to proper result format
    if results.count >0
      results.each do |each_data|
        result["sub"]=ActiveSupport::NumberHelper.number_to_delimited(each_data["sub"])
        result["usub"]=ActiveSupport::NumberHelper.number_to_delimited(each_data["usub"])
        result["usup3"]=ActiveSupport::NumberHelper.number_to_delimited(each_data["usup3"])
        result["usup7"]=ActiveSupport::NumberHelper.number_to_delimited(each_data["usup7"])
        result["usup15"]=ActiveSupport::NumberHelper.number_to_delimited(each_data["usup15"])
        result["rl"]=ActiveSupport::NumberHelper.number_to_delimited(each_data["rl"],unit: report_request["currency"])
        result["rd"]=ActiveSupport::NumberHelper.number_to_delimited(each_data["rd"])


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
    if report_request["cids"].length >0
      filters["cid"]={"$in"=> report_request["cids"]}
    end

    filter= { "$match" => filters }

    group={"$group"=> { "_id" => {"d"=>"$d","cn"=>"$cn","cid"=>"$cid","sc"=>"$sc",
                                  "am"=>"$am","loc"=>"$loc","lmc"=>"$lmc"},
                        "ucl"=>{ "$sum"=>"$ucl.v"},"ucd"=>{ "$sum"=>"$ucd.v"},"sup"=>{ "$sum"=>"$sup.v"},"usup"=>{ "$sum"=>"$usup.v"},"usup3"=>{ "$sum"=>"usup3.v"},
                        "usup7"=>{ "$sum"=>"$usup7.v"},"usup15"=>{ "$sum"=>"$usup15.v"},
                        "asub"=>{ "$sum"=>"$asub.v"}, "nsup"=>{ "$sum"=>"$nsup.v"},"mtsp"=>{ "$sum"=>"$mtsp.v"},"mssp"=>{ "$sum"=>"$mssp.v"},"rl"=>{ "$sum"=>"$rl.v"},"rd"=>{ "$sum"=>"$rd.v"},
                        "arpsl"=>{ "$sum"=>"$arpsl.v"},"arpsd"=>{ "$sum"=>"$arpsd.v"}, "cpasl"=>{ "$sum"=>"$cpasl.v"},"cpasd"=>{ "$sum"=>"$cpasd.v"},
                        "proil"=>{ "$sum"=>"$proil.v"},"proid"=>{ "$sum"=>"$proid.v"}, "droil"=>{ "$sum"=>"$droil.v"},"droid"=>{ "$sum"=>"$droid.v"}

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
    if report_request["cids"].length >0
      filters["cid"]={"$in"=> report_request["cids"]}
    end

    filter= { "$match" => filters }

    group={"$group"=> { "_id" => {},
                        "sup"=>{ "$sum"=>"$sup.v"},"usup"=>{ "$sum"=>"$usup.v"},"usup3"=>{ "$sum"=>"usup3.v"},
                        "usup7"=>{ "$sum"=>"$usup15.v"},"usup15"=>{ "$sum"=>"$usup15.v"},"rl"=>{ "$sum"=>"$rl.v"},"rd"=>{ "$sum"=>"$rd.v"}
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
        result.push("")
        result.push("")
        result.push(each_data["rl"])
        result.push(each_data["rd"])
        result.push("")
        result.push("")
        result.push("")
        result.push("")
        result.push("")
        result.push("")
        result.push("")
        result.push("")
      end
    end
    return result
  end





end
