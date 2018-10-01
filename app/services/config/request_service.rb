class Config::RequestService < ApplicationService

  def get_list_parameters(params)
    search=Regexp.new(".*")
    sort="date"
    limit=10
    order="desc"
    offset=0
    if params[:limit] && params[:limit].length >0
      limit=params[:limit].to_i
    end
    if params[:offset] && params[:offset].length >0
      offset=params[:offset].to_i
      offset =  (offset.to_i - 1)*limit.to_i
    end
    if params[:order] && params[:order].length >0
      order=params[:order]
    end
    if params[:search] && params[:search].length >0
      search=Regexp.new(".*"+params[:search]+".*")
    end
    if params[:sort] && params[:sort].length >0
      sort=params[:sort]
    end
    return limit,offset,order,search,sort
  end

  def get_report_parameters(params)
    campaign_ids=[]
    me_ids=[]
    op_ids=[]
    s_date=DateUtility.getUtcStartDateFromDate(Time.now.utc)
    e_date=DateUtility.getUtcStartDateFromDate(Time.now.utc)
    if params[:cids] && params[:cids].length >0
      campaign_ids=params[:cids].split(',')
    end
    if params[:meids] && params[:meids].length >0
      me_ids=params[:meids].split(',')
    end
    if params[:opids] && params[:opids].length >0
      op_ids=params[:opids].split(',')
    end
    if params[:sdate] && params[:sdate].length >0
      s_date=DateUtility.getUtcStartDateFromDate(params[:sdate].to_date)
    end
    if params[:edate] && params[:edate].length >0
      e_date=DateUtility.getUtcStartDateFromDate(params[:edate].to_date)
    end

    return campaign_ids,me_ids,op_ids,s_date,e_date
  end

  def get_view_report_parameters(params,report_request)

    #default data
    offset=0
    sort="date"
    limit=10
    order="desc"
    campaign_ids, me_ids,op_ids,msisdn_ids=[],[],[],[]
    s_date=DateUtility.getUtcStartDateFromDate(Time.now.utc)
    e_date=DateUtility.getUtcStartDateFromDate(Time.now.utc)

    #from request
    if params[:limit] && params[:limit].length >0
      limit=params[:limit].to_i
    end
    if params[:offset] && params[:offset].length >0
      offset=params[:offset].to_i
      offset =  (offset.to_i - 1)*limit.to_i
    end
    if params[:order] && params[:order].length >0
      order=params[:order]
    end
    if params[:sort] && params[:sort].length >0
      sort=params[:sort]
    end
    if params[:cids] && params[:cids].length >0
      campaign_ids=params[:cids].split(',')
    end
    if params[:meids] && params[:meids].length >0
      me_ids=params[:meids].split(',')
    end
    if params[:opids] && params[:opids].length >0
      op_ids=params[:opids].split(',')
    end

    if params[:msids] && params[:msids].length >0
      splitted_msisdn_ids=params[:msids].split(',')
      splitted_msisdn_ids.each do |msisdn|
        search=Regexp.new(".*"+msisdn+".*")
        msisdn_ids.push(search)
      end
    end
    if params[:sdate] && params[:sdate].length >0
      s_date=DateUtility.getUtcStartDateFromDate(params[:sdate].to_date)
    end
    if params[:edate] && params[:edate].length >0
      e_date=DateUtility.getUtcStartDateFromDate(params[:edate].to_date)
    end

    report_request[LIMIT]=limit
    report_request[OFFSET]=offset
    report_request[ORDER]=order
    report_request[SORT]=sort
    report_request[SDATE]=s_date
    report_request[EDATE]=e_date
    report_request[CIDS]=campaign_ids
    report_request[MEIDS]=me_ids
    report_request[OPIDS]=op_ids
    report_request[MSIDS]=msisdn_ids

    return report_request
  end



  def get_download_report_parameters(params,report_request)

    #default data
    sort="date"
    order=1
    campaign_ids, me_ids,op_ids,msisdn_ids=[],[],[],[]
    s_date=DateUtility.getUtcStartDateFromDate(Time.now.utc)
    e_date=DateUtility.getUtcStartDateFromDate(Time.now.utc)

    if params[:order] && params[:order].length >0
      if params[:order]=="asc"
        order=-1
        end
    end
    if params[:sort] && params[:sort].length >0
      sort=params[:sort]
    end
    if params[:cids] && params[:cids].length >0
      campaign_ids=params[:cids].split(',')
    end
    if params[:meids] && params[:meids].length >0
      me_ids=params[:meids].split(',')
    end
    if params[:opids] && params[:opids].length >0
      op_ids=params[:opids].split(',')
    end
    if params[:msids] && params[:msids].length >0
      splitted_msisdn_ids=params[:msids].split(',')
      splitted_msisdn_ids.each do |msisdn|
        search=Regexp.new(".*"+msisdn+".*")
        msisdn_ids.push(search)
      end
    end
    if params[:sdate] && params[:sdate].length >0
      s_date=DateUtility.getUtcStartDateFromDate(params[:sdate].to_date)
    end
    if params[:edate] && params[:edate].length >0
      e_date=DateUtility.getUtcStartDateFromDate(params[:edate].to_date)
    end

    report_request[ORDER]=order
    report_request[SORT]=sort
    report_request[SDATE]=s_date
    report_request[EDATE]=e_date
    report_request[CIDS]=campaign_ids
    report_request[MEIDS]=me_ids
    report_request[OPIDS]=op_ids
    report_request[MSIDS]=msisdn_ids

    return report_request
  end

  def get_exception_parameters(params)
    search=Regexp.new(".*")
    if params[:search] && params[:search].length >0
      search=Regexp.new(".*"+params[:search]+".*")
    end
    return search
  end

end