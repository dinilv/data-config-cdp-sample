class Msisdn::Lifetime

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
  field :a,       as: :active, type: Boolean, default: true
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
  field :mn,      as: :media_name, type: String
  field :mpd,     as: :media_payout_dollar , type: Dollar
  field :mpl,     as: :media_payout_local, type: Amount

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

  index(cyid:1,cid: 1, meid: 1, d: 1,a:1 )

  def self.update_active(c_id,me_id,op_id,msisdn,date)
    where( :cid => c_id, :meid => me_id,:oid=> op_id, :msid =>msisdn ,:d => {
        "$lte" => date}).update_all(:a => false)
  end

  def self.delete_existing(c_id,me_id,op_id,msisdn,date)
    where( :cid => c_id, :meid => me_id,:oid=> op_id, :msid =>msisdn ,:d => date).delete
  end

  def self.delete_by_date(date)
    where(:d => date).delete
  end

  def self.find_by_msidn(c_id,me_id,op_id,msisdn,date)
    where( :cid => c_id, :meid => me_id,:oid=> op_id, :msid =>msisdn ,:d => {
        "$lte" => date}).desc("d").first
  end

  def self.find_by_cp(cy_id,msisdn)
    where( :cid => c_id, :meid => me_id,:oid=> op_id, :msid =>msisdn ,:d => {
        "$lte" => date}).desc("d").first
  end

  def self.get_count_report(report_request)
    or_fillter= []
    report_request["msids"].each do |msisdn|
      or_fillter.push({"msid"=> msisdn})
    end
    count=0
    if report_request["cyid"]=="1"
      count=where("$or"=> or_fillter).count
    else
      count=where(:cyid=>report_request["cyid"],"$or"=> or_fillter).count
    end

    return count

  end

  def self.get_view_report(report_request)
    or_fillter= []
    report_request["msids"].each do |msisdn|
      or_fillter.push({:msid=> msisdn})
    end
    #admin account
    if report_request["cyid"]=="1"
      data=where(:a=>true,"$or"=> or_fillter).only("msisdn","campaign_name","service_code","country",
                                                         "acquisition_model","landing_page","keyword","unit_charge_local","unit_charge_dollar","operator_name",
                                                         "media_name","subscriptions","mt_sent","mt_success",
                                                         "mt_success_percent","mt_fail","mt_delivered","content_views","content_view_percent",
                                                         "revenue_local","revenue_dollar","cost_per_active_subscriber_dollar",
                                                                          "cost_per_active_subscriber_local","media_cost_local","media_cost_dollar")
        .order(report_request["sort"]=>report_request["order"])
        .skip(report_request["offset"]).limit(report_request["limit"])
    else
      data=where(:cyid=>report_request["cyid"],:a=>true,"$or"=> or_fillter).only("msisdn","campaign_name","service_code","country",
                                                                                 "acquisition_model","landing_page","keyword","unit_charge_local","unit_charge_dollar","operator_name",
                                                                                 "media_name","subscriptions","mt_sent","mt_success",
                                                                                 "mt_success_percent","mt_fail","mt_delivered","content_views","content_view_percent",
                                                                                 "revenue_local","revenue_dollar","cost_per_active_subscriber_dollar",
                                                                                 "cost_per_active_subscriber_local","media_cost_local","media_cost_dollar")
               .order(report_request["sort"]=>report_request["order"])
               .skip(report_request["offset"]).limit(report_request["limit"])

    end

    return data
  end

  def self.get_total_report(report_request)

    or_fillter= []
    report_request["msids"].each do |msisdn|
      or_fillter.push({:msid=> msisdn})
    end

    filters= { "$match" => {:cyid =>report_request["cyid"],:a=>true,"$or"=> or_fillter }
    }

    #admin account
    if report_request["cyid"]=="1"
      filters= { "$match" => {:a=>true,"$or"=> or_fillter }
      }
    end
    group={"$group"=> { "_id" => {},
                        "sup"=>{ "$sum"=>"$sup.v"},"usup"=>{ "$sum"=>"$usup.v"},
                        "mts"=>{ "$sum"=>"$mts.v"},"mtss"=>{ "$sum"=>"$mtss.v"},
                        "mtf"=>{ "$sum"=>"$mtf.v"},"mtd"=>{ "$sum"=>"$mtd.v"},"cv"=>{ "$sum"=>"$cv.v"},
                        "rl"=>{ "$sum"=>"$rl.v"},"rd"=>{ "$sum"=>"$rd.v"}



    }
    }

    results=collection.aggregate([filters,group])
    result={}
    #parse it to proper result format
    if results.count >0
      results.each do |each_data|

        result["sup"]=ActiveSupport::NumberHelper.number_to_delimited(each_data["sup"])
        result["usup"]=ActiveSupport::NumberHelper.number_to_delimited(each_data["usup"])
        result["usup3"]=ActiveSupport::NumberHelper.number_to_delimited(each_data["mts"])
        result["usup7"]=ActiveSupport::NumberHelper.number_to_delimited(each_data["mtss"])
        result["usup15"]=ActiveSupport::NumberHelper.number_to_delimited(each_data["mtf"])
        result["usup7"]=ActiveSupport::NumberHelper.number_to_delimited(each_data["mtd"])
        result["usup15"]=ActiveSupport::NumberHelper.number_to_delimited(each_data["cv"])
        result["rl"]= ActiveSupport::NumberHelper.number_to_currency(each_data["rl"],unit: report_request["currency"])
        result["rd"]= ActiveSupport::NumberHelper.number_to_currency(each_data["rd"])

      end
    end
    return result

  end


  def self.get_download_report(report_request)

    or_fillter= []
    report_request["msids"].each do |msisdn|
      or_fillter.push({:msid=> msisdn})
    end

    filters= { "$match" => {:cyid =>report_request["cyid"],:a=>true,"$or"=> or_fillter }
    }

    group={"$group"=> { "_id" => {"d"=>"$d","msid"=>"$msid","cid"=>"$cid","cn"=>"$cn","sc"=> "$sc",
                         "c"=>"$c","am"=>"$am","lp"=>"$lp","ky"=>"$ky","on"=> "$on","mn"=> "$mn"},
                        "ucl"=>{"$sum"=>"$ucl.v"}, "ucd"=>{ "$sum"=>"$ucd.v"},
                        "sup"=>{ "$sum"=>"$sup.v"},"mts"=>{ "$sum"=>"$mts.v"},"mtss"=>{ "$sum"=>"$mtss.v"},"mssp"=>{ "$sum"=>"$mssp.v"},
                        "mtf"=>{ "$sum"=>"$mtf.v"},"mtd"=>{ "$sum"=>"$mtd.v"},"cv"=>{ "$sum"=>"$cv.v"},"cvp"=>{ "$sum"=>"$cvp.v"},
                        "rl"=>{ "$sum"=>"$rl.v"},"rd"=>{ "$sum"=>"$rd.v"},"cpasl"=>{ "$sum"=>"$cpasl.v"}, "cpasd"=>{ "$sum"=>"$cpasd.v"}
    }


    }
    sort={"$sort"=> {"_id.d"=> 1} }

    collection.aggregate([filters,group,sort])
  end


  def self.get_csv_total_report(report_request)

    or_fillter= []
    report_request["msids"].each do |msisdn|
      or_fillter.push({:msid=> msisdn})
    end

    filters= { "$match" => {:cyid =>report_request["cyid"],:a=>true,"$or"=> or_fillter }
    }

    group={"$group"=> { "_id" => {},
                        "sup"=>{ "$sum"=>"$sup.v"},"usup"=>{ "$sum"=>"$usup.v"},
                        "mts"=>{ "$sum"=>"$mts.v"},"mtss"=>{ "$sum"=>"$mtss.v"},
                        "mtf"=>{ "$sum"=>"$mtf.v"},"mtd"=>{ "$sum"=>"$mtd.v"},"cv"=>{ "$sum"=>"$cv.v"},
                        "rl"=>{ "$sum"=>"$rl.v"},"rd"=>{ "$sum"=>"$rd.v"}
    }

    }

    results=collection.aggregate([filters,group])
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
        result.push("")
        result.push("")
        result.push("")
        # result["mts"]=each_data["mts"]
        # result["mtss"]=each_data["mtss"]
        # result["mssp"]=each_data["mssp"]
        # result["mtf"]=each_data["mtf"]
        # result["mtd"]=each_data["mtd"]
        # result["cv"]=each_data["cv"]
        # result["cvp"]=each_data["cvp"]
        # result["rl"]=each_data["rl"]
        # result["rd"]=each_data["rd"]
        # result["cpasl"]=each_data["cpasl"]
        # result["cpasd"]=each_data["cpasd"]
        result.push(each_data["sup"])
        result.push(each_data["usup"])
        result.push(each_data["mts"])
        result.push(each_data["mtss"])
        result.push("")
        result.push(each_data["mtf"])
        result.push(each_data["mtd"])
        result.push(each_data["cv"])
        result.push("")
        result.push(each_data["rl"])
        result.push(each_data["rd"])

      end
    end
    return result
  end
end




