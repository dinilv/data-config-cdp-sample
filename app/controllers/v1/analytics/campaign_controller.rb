class V1::Analytics::CampaignController < ApplicationController
    before_action :authorize, :only => [:list,:details,:graph,:current,:media,:operator,:media_stats,:campaign_stats]
    before_action :token_renew, :only => [:list, :index, :details, :graph]
    def list
        begin
          formatted_date=DateUtility.getUtcStartDateFromDate(Time.now.utc())
          response = SUCCESS.dup
          response[CURRENCY]=CURRENCY_SYMBOL[@auth_token[CURRENCY_ID]]
          limit,offset,order,search,sort=@@request_service.get_list_parameters(params)
          response[COUNT]= Campaign::SummaryLifetime.campaign_count(@auth_token[COMPANY_ID],search,
                                                                      formatted_date)
          response[DATA] = Campaign::SummaryLifetime.listing(@auth_token[COMPANY_ID],search,offset,limit,
                                                                      sort,order,formatted_date)
          render :json => response, :status => response[STATUS_CODE]
        rescue Exception => e
          puts e
            exception_job = {:controller_action => "campaign_list", :exception => e.message ,
                             :backtrace => e.backtrace.inspect}
            Resque.enqueue(ExceptionLogJob,exception_job)
            response = EXCEPTION.dup
            render :json => response, :status => response[EXCEPTION]
        end
    end

  def details
    begin
      response = SUCCESS.dup
      response[DATA]= Campaign::SummaryLifetime.details(params[:id])[0]
      response[CURRENCY]=CURRENCY_SYMBOL[@auth_token[CURRENCY_ID]]
      render :json => response, :status => response[STATUS_CODE]
    rescue Exception => e
      puts e
      exception_job = {:controller_action => "campaign_details", :exception => e.message ,
                       :backtrace => e.backtrace.inspect}
      Resque.enqueue(ExceptionLogJob,exception_job)
      response = EXCEPTION.dup
      render :json => response, :status => response[EXCEPTION]
    end

  end

  def graph
    begin
      now=Time.now.utc
      response =SUCCESS.dup
      start_date=DateUtility.getUtcStartDateFromDateAndDays(now,14)
      end_date=DateUtility.getUtcStartDateFromDateAndDays(now,0)

      #default data
      max_sub,max_arpul,max_asub,max_usub,max_vsup,max_nsup,max_rl,max_nrl,max_mdcl=0,0,0,0,0,0,0,0,0
      factor_sub,factor_nsub,factor_arpul,factor_asub,factor_usub,factor_vsup,factor_rl,factor_nrl,factor_mdcl=ONE,ONE,ONE,ONE,ONE,ONE,ONE,ONE,ONE,ONE
      graph_ids,subscribers,active_subscribers,un_subcriptions,arpul,valid_subscriptions,mssp,rl,nrl,mcl,nsup=[],[],[],[],[],[],[],[],[],[],[],[],[],[],[]

      #query
      unformatted_data= Campaign::SummaryDaily.graph(@auth_token[COMPANY_ID],params[:id],start_date,end_date)
      max_values_graph=Campaign::SummaryDaily.max_value_graph(@auth_token[COMPANY_ID],params[:id],start_date,end_date)
      left_axis_max_value=100
      right_axis_max_value=10
      #assign max values
      max_values_graph.each do |each_data|
        factor_asub=ApiUtility.find_factor(each_data[ASUB_MAX])
        factor_usub=ApiUtility.find_factor(each_data[USUP_MAX])
        factor_sub=ApiUtility.find_factor(each_data[SUB_MAX])
        factor_vsup=ApiUtility.find_factor(each_data[VSUP_MAX])
        factor_arpul=ApiUtility.find_factor(each_data[ARPSL_MAX])
        factor_rl=ApiUtility.find_factor(each_data[RL_MAX])
        factor_nrl=ApiUtility.find_factor(each_data[NRL_MAX])
        factor_mdcl=ApiUtility.find_factor(each_data[MDCL_MAX])
        left_axis_max_value=ApiUtility.find_graph_axis_value(factor_asub,each_data[ASUB_MAX])
        right_axis_max_value=ApiUtility.find_graph_axis_value(factor_arpul,each_data[ARPSL_MAX])
      end

      #format result
      unformatted_data.each do|each_data|
        #formatted numbers
        subscribers.push(ApiUtility.format_value(factor_sub,each_data[SUBSCRIBERS_SHORT]))
        active_subscribers.push(ApiUtility.format_value(factor_asub,each_data[ACTIVE_SUBSCRIBERS_SHORT]))
        un_subcriptions.push(ApiUtility.format_value(factor_usub,each_data[UN_SUBSCRIPTIONS_SHORT]))
        valid_subscriptions.push(ApiUtility.format_value(factor_vsup,each_data[VALID_SUBSCRIPTIONS_SHORT]))
        mssp.push(ApiUtility.format_value(factor_vsup,each_data[MT_SUCCESS_SHORT]))
        rl.push(ApiUtility.format_value(factor_rl,each_data[REVENUE_LOCAL_SHORT]))
        nrl .push(ApiUtility.format_value(factor_nrl,each_data[NET_REVENUE_LOCAL_SHORT]))
        mcl.push(ApiUtility.format_value(factor_rl,each_data[MEDIA_COST_LOCAL_SHORT]))
        arpul.push(ApiUtility.format_value(factor_arpul,each_data[AVERAGE_REVENUE_PER_SUBSCRIBER_LOCAL_SHORT]))
        #text data
        graph_ids.push(each_data[ID_][GRAPH_ID_SHORT])
        nsup.push(each_data[NEW_SUB_UNSUB_PERCENT_SHORT])
        mssp.push(each_data[MT_SUCCESS_PERCENT_SHORT])

      end
      data_formatted={}
      #meta data first
      data_formatted[LEFT_AXIS_MAX]=left_axis_max_value
      data_formatted[RIGHT_AXIS_MAX]=right_axis_max_value
      #factors for each stats
      data_formatted[SUBSCRIBERS_FORMATTED]=factor_sub
      data_formatted[ACTIVE_SUBSCRIBERS_FORMATTED]=factor_asub
      data_formatted[UN_SUBSCRIPTIONS_FORMATTED]=factor_usub
      data_formatted[VALID_SUBSCRIPTIONS_FORMATTED]=factor_vsup
      data_formatted[REVENUE_LOCAL_FORMATTED]=factor_rl
      data_formatted[NET_REVENUE_LOCAL_FORMATTED]=factor_nrl
      data_formatted[MEDIA_COST_LOCAL_FORMATTED]=factor_mdcl
      data_formatted[AVERAGE_REVENUE_PER_SUBSCRIBER_LOCAL_FORMATTED]=factor_arpul

      #number data for pop-over & graph
      data_formatted[SUBSCRIBERS_SHORT]=subscribers
      data_formatted[ACTIVE_SUBSCRIBERS_SHORT]=active_subscribers
      data_formatted[UN_SUBSCRIPTIONS_SHORT]=un_subcriptions
      data_formatted[VALID_SUBSCRIPTIONS_SHORT]=valid_subscriptions
      data_formatted[REVENUE_LOCAL_SHORT]=rl
      data_formatted[NET_REVENUE_LOCAL_SHORT]=nrl
      data_formatted[MEDIA_COST_LOCAL_SHORT]=mcl
      data_formatted[AVERAGE_REVENUE_PER_SUBSCRIBER_LOCAL_SHORT]=arpul
      #text data
      data_formatted[GRAPH_ID_SHORT]=graph_ids
      data_formatted[NEW_SUB_UNSUB_PERCENT_SHORT]=nsup
      data_formatted[MT_SUCCESS_PERCENT_SHORT]=mssp
      response[DATA] = data_formatted
      response[CURRENCY]=CURRENCY_SYMBOL[@auth_token[CURRENCY_ID]]
      render :json => response, :status => response[STATUS_CODE]
    rescue Exception => e
      puts e
      exception_job = {:controller_action => "campaign_graph", :exception => e.message ,
                       :backtrace => e.backtrace.inspect}
      Resque.enqueue(ExceptionLogJob,exception_job)
      response = EXCEPTION.dup
      render :json => response, :status => response[EXCEPTION]
    end
  end

  def current
    begin
      now=Time.now.utc
      response = SUCCESS.dup
      response[CURRENCY]=CURRENCY_SYMBOL[@auth_token[CURRENCY_ID]]
      data=Campaign::SummaryDaily.current(@auth_token[COMPANY_ID],params[:id],now)
      data.each do  |obj|
        response[DATA] = obj
      end
      render :json => response, :status => response[STATUS_CODE]
    rescue Exception => e
      puts e
      exception_job = {:controller_action => "current_performance", :exception => e.message ,
                       :backtrace => e.backtrace.inspect}
      Resque.enqueue(ExceptionLogJob,exception_job)
      response = EXCEPTION.dup
      render :json => response, :status => response[EXCEPTION]
    end
  end

  def media_stats
    begin
      now=Time.now.utc
      response =SUCCESS.dup
      start_date=DateUtility.getUtcStartDateFromDateAndDays(now,14)
      end_date=DateUtility.getUtcStartDateFromDateAndDays(now,0)

      #default data
      max_sub,max_asub,max_usub,max_vsup,max_nsup,max_rl,max_nrl,max_mdcl=0,0,0,0,0,0,0,0,0
      factor_sub,factor_asub,factor_usub,factor_vsup,factor_mssp,factor_rl,factor_nrl,factor_mdcl=ONE,ONE,ONE,ONE,ONE,ONE,ONE,ONE
      left_axis_max_value=100

      #query
      unformatted_data= Campaign::MediaDaily.graph(params[:id],start_date,end_date)
      max_values_graph= Campaign::MediaDaily.max_value_graph(params[:id],start_date,end_date)

      #assign max values
      max_values_graph.each do |each_data|
        factor_sub=ApiUtility.find_factor(each_data[SUB_MAX])
        factor_asub=ApiUtility.find_factor(each_data[ASUB_MAX])
        factor_usub=ApiUtility.find_factor(each_data[USUP_MAX])
        factor_vsup=ApiUtility.find_factor(each_data[VSUP_MAX])
        factor_rl=ApiUtility.find_factor(each_data[RL_MAX])
        factor_nrl=ApiUtility.find_factor(each_data[NRL_MAX])
        factor_mdcl=ApiUtility.find_factor(each_data[MDCL_MAX])
        left_axis_max_value=ApiUtility.find_graph_axis_value(factor_mdcl,each_data[MDCL_MAX])
      end

      media_graphs=Hash.new
      unformatted_data.each do|each_data|
        existing={}
        if  media_graphs[each_data[ID_][MEDIA_ID_SHORT]]
          existing=media_graphs[each_data[ID_][MEDIA_ID_SHORT]]
        else
          #zero data
          data_formatted={}
          data_formatted[GRAPH_ID_SHORT]=[]
          data_formatted[SUBSCRIBERS_SHORT]=[]
          data_formatted[ACTIVE_SUBSCRIBERS_SHORT]=[]
          data_formatted[UN_SUBSCRIPTIONS_SHORT]=[]
          data_formatted[VALID_SUBSCRIPTIONS_SHORT]=[]
          data_formatted[REVENUE_LOCAL_SHORT]=[]
          data_formatted[NET_REVENUE_LOCAL_SHORT]=[]
          data_formatted[MEDIA_COST_LOCAL_SHORT]=[]
          data_formatted[NEW_SUB_UNSUB_PERCENT_SHORT]=[]
          data_formatted[MT_SUCCESS_PERCENT_SHORT]=[]
          media_graphs[each_data[ID_][MEDIA_ID_SHORT]]=data_formatted
          existing=media_graphs[each_data[ID_][MEDIA_ID_SHORT]]
        end
        #format numbers
        existing[SUBSCRIBERS_SHORT].push(ApiUtility.format_value(factor_sub,each_data[SUBSCRIBERS_SHORT]))
        existing[ACTIVE_SUBSCRIBERS_SHORT].push(ApiUtility.format_value(factor_asub,each_data[ACTIVE_SUBSCRIBERS_SHORT]))
        existing[UN_SUBSCRIPTIONS_SHORT].push(ApiUtility.format_value(factor_usub,each_data[UN_SUBSCRIPTIONS_SHORT]))
        existing[VALID_SUBSCRIPTIONS_SHORT].push(ApiUtility.format_value(factor_vsup,each_data[VALID_SUBSCRIPTIONS_SHORT]))
        existing[REVENUE_LOCAL_SHORT].push(ApiUtility.format_value(factor_rl,each_data[REVENUE_LOCAL_SHORT]))
        existing[NET_REVENUE_LOCAL_SHORT].push(ApiUtility.format_value(factor_nrl,each_data[NET_REVENUE_LOCAL_SHORT]))
        existing[MEDIA_COST_LOCAL_SHORT].push(ApiUtility.format_value(factor_mdcl,each_data[MEDIA_COST_LOCAL_SHORT]))

        existing[GRAPH_ID_SHORT].push(each_data[ID_][GRAPH_ID_SHORT])
        existing[NEW_SUB_UNSUB_PERCENT_SHORT].push(each_data[NEW_SUB_UNSUB_PERCENT_SHORT])
        existing[MT_SUCCESS_PERCENT_SHORT].push(each_data[MT_SUCCESS_PERCENT_SHORT])
        media_graphs[each_data[ID_][MEDIA_ID_SHORT]]=existing
      end

      #factors for each stats
      media_graphs[SUBSCRIBERS_FORMATTED]=factor_sub
      media_graphs[ACTIVE_SUBSCRIBERS_FORMATTED]=factor_asub
      media_graphs[UN_SUBSCRIPTIONS_FORMATTED]=factor_usub
      media_graphs[VALID_SUBSCRIPTIONS_FORMATTED]=factor_vsup
      media_graphs[REVENUE_LOCAL_FORMATTED]=factor_rl
      media_graphs[NET_REVENUE_LOCAL_FORMATTED]=factor_nrl
      media_graphs[MEDIA_COST_LOCAL_FORMATTED]=factor_mdcl
      media_graphs[LEFT_AXIS_MAX]=left_axis_max_value
      response[DATA]=media_graphs
      response[CURRENCY]=CURRENCY_SYMBOL[@auth_token[CURRENCY_ID]]
      render :json => response, :status => response[STATUS_CODE]
    rescue Exception => e
      puts e,e.backtrace
      exception_job = {:controller_action => "campaign_graph", :exception => e.message ,
                       :backtrace => e.backtrace.inspect,:version=>"v1"}
      Resque.enqueue(ExceptionLogJob,exception_job)
      response = EXCEPTION.dup
      render :json => response, :status => response[EXCEPTION]
    end
  end

  def campaign_stats
    begin
      now=Time.now.utc
      response =SUCCESS.dup
      start_date=DateUtility.getUtcStartDateFromDateAndDays(now,14)
      end_date=DateUtility.getUtcStartDateFromDateAndDays(now,0)
      unformatted_data= Campaign::SummaryDaily.track_graph(@auth_token[COMPANY_ID],params[:id],start_date,end_date)
      max_values_graph=Campaign::SummaryDaily.max_value_track_graph(@auth_token[COMPANY_ID],params[:id],start_date,end_date)

      #default data
      max_sub,max_arpul,max_asub,max_usub,max_vsup,max_nsup,max_rl,max_nrl,max_mdcl=0,0,0,0,0,0,0,0,0

      factor_sub,factor_asub,factor_usub,factor_vsub,factor_arpul,factor_lpv,factor_ilpv,factor_ie=ONE,ONE,ONE,ONE,ONE,ONE,ONE,ONE
      factor_e,factor_bc,factor_ibc,factor_isup,factor_mts,factor_mtss,factor_mtso,factor_rl,factor_nrl,factor_mdcl=ONE,ONE,ONE,ONE,ONE,ONE,ONE,ONE,ONE,ONE
      graph_ids,subscribers,active_subscribers,un_subcriptions,arpul,valid_subscriptions,nsup,ibc,nrl=[],[],[],[],[],[],[],[],[]
      mssp,rl,nl,mcl,lpv,e,bc,ilpv,ie,isup,mts,mtss,mtso=[],[],[],[],[],[],[],[],[],[],[],[],[]
      left_axis_conv_max_value=100
      left_axis_traffic_max_value=100
      left_axis_billable_max_value=100
      left_axis_roi_max_value=100

      #assign max values
      max_values_graph.each do |each_data|
        factor_sub=ApiUtility.find_factor(each_data[SUB_MAX])
        factor_asub=ApiUtility.find_factor(each_data[ASUB_MAX])
        factor_usub=ApiUtility.find_factor(each_data[USUP_MAX])
        factor_vsup=ApiUtility.find_factor(each_data[VSUP_MAX])
        factor_lpv=ApiUtility.find_factor(each_data[LPV_MAX])
        factor_ilpv=ApiUtility.find_factor(each_data[ILPV_MAX])
        factor_e=ApiUtility.find_factor(each_data[E_MAX])
        factor_ie=ApiUtility.find_factor(each_data[IE_MAX])
        factor_bc=ApiUtility.find_factor(each_data[BC_MAX])
        factor_ibc=ApiUtility.find_factor(each_data[IBC_MAX])
        factor_mts=ApiUtility.find_factor(each_data[MS_MAX])
        factor_mtss=ApiUtility.find_factor(each_data[MSS_MAX])
        factor_mtso=ApiUtility.find_factor(each_data[MSO_MAX])
        factor_arpul=ApiUtility.find_factor(each_data[ARPSL_MAX])
        factor_rl=ApiUtility.find_factor(each_data[RL_MAX])
        factor_nrl=ApiUtility.find_factor(each_data[NRL_MAX])
        factor_mdcl=ApiUtility.find_factor(each_data[MDCL_MAX])
        left_axis_conv_max_value=ApiUtility.find_graph_axis_value(factor_e,each_data[E_MAX])
        left_axis_traffic_max_value=ApiUtility.find_graph_axis_value(factor_bc,each_data[BC_MAX])
        left_axis_billable_max_value=ApiUtility.find_graph_axis_value(factor_mts,each_data[MS_MAX])
        left_axis_roi_max_value=ApiUtility.find_graph_axis_value(factor_asub,each_data[ASUB_MAX])
      end

      unformatted_data.each do|each_data|
        #number data
        subscribers.push(ApiUtility.format_value(factor_sub,each_data[SUBSCRIBERS_SHORT]))
        active_subscribers.push(ApiUtility.format_value(factor_asub,each_data[ACTIVE_SUBSCRIBERS_SHORT]))
        un_subcriptions.push(ApiUtility.format_value(factor_usub,each_data[UN_SUBSCRIPTIONS_SHORT]))
        valid_subscriptions.push(ApiUtility.format_value(factor_usub,each_data[VALID_SUBSCRIPTIONS_SHORT]))
        lpv.push(ApiUtility.format_value(factor_lpv,each_data[LANDING_PAGE_VIEWS_SHORT]))
        e.push(ApiUtility.format_value(factor_e,each_data[ENGAGMENTS_SHORT]))
        bc.push(ApiUtility.format_value(factor_bc,each_data[BANNER_CLICKS_SHORT]))
        ilpv.push(ApiUtility.format_value(factor_ilpv,each_data[INVALID_LANDING_PAGE_VIEWS_SHORT]))
        ie.push(ApiUtility.format_value(factor_ie,each_data[INVALID_ENGAGMENTS_SHORT]))
        ibc.push(ApiUtility.format_value(factor_ibc,each_data[INVALID_BANNER_CLICKS_SHORT]))
        mts.push(ApiUtility.format_value(factor_e,each_data[MT_SENT_SHORT]))
        mtss.push(ApiUtility.format_value(factor_e,each_data[MT_SUCCESS_SHORT]))
        mtso.push(ApiUtility.format_value(factor_e,each_data[MT_SENT_BY_OPERATOR_SHORT]))
        arpul.push(ApiUtility.format_value(factor_arpul,each_data[AVERAGE_REVENUE_PER_SUBSCRIBER_LOCAL_SHORT]))
        rl.push(ApiUtility.format_value(factor_rl,each_data[REVENUE_LOCAL_SHORT]))
        nrl .push(ApiUtility.format_value(factor_nrl,each_data[NET_REVENUE_LOCAL_SHORT]))
        mcl.push(ApiUtility.format_value(factor_rl,each_data[MEDIA_COST_LOCAL_SHORT]))

        #text data
        graph_ids.push(each_data[ID_][GRAPH_ID_SHORT])
        nsup.push(each_data[NEW_SUB_UNSUB_PERCENT_SHORT])
        mssp.push(each_data[MT_SUCCESS_PERCENT_SHORT])

      end
      data_formatted={}

      #max values for axis
      data_formatted[LEFT_AXIS_CONV_MAX]=left_axis_conv_max_value
      data_formatted[LEFT_AXIS_TRAFFIC_MAX]=left_axis_traffic_max_value
      data_formatted[LEFT_AXIS_ROI_MAX]=left_axis_roi_max_value
      data_formatted[LEFT_AXIS_BILL_MAX]=left_axis_billable_max_value

       #factors
      data_formatted[SUBSCRIBERS_FORMATTED]=factor_sub
      data_formatted[ACTIVE_SUBSCRIBERS_FORMATTED]=factor_asub
      data_formatted[UN_SUBSCRIPTIONS_FORMATTED]=factor_usub
      data_formatted[VALID_SUBSCRIPTIONS_FORMATTED]=factor_vsub
      data_formatted[LANDING_PAGE_VIEWS_FORMATTED]=factor_lpv
      data_formatted[ENGAGMENTS_FORMATTED]=factor_e
      data_formatted[BANNER_CLICKS_FORMATTED]=factor_bc
      data_formatted[INVALID_LANDING_PAGE_VIEWS_FORMATTED]=factor_ilpv
      data_formatted[INVALID_ENGAGMENTS_FORMATTED]=factor_ie
      data_formatted[INVALID_SUBSCRIPTIONS_FORMATTED]=factor_isup
      data_formatted[MT_SENT_FORMATTED]=factor_mts
      data_formatted[MT_SUCCESS_FORMATTED]=factor_mtss
      data_formatted[MT_SENT_BY_OPERATOR_FORMATTED]=factor_mtso
      data_formatted[AVERAGE_REVENUE_PER_SUBSCRIBER_LOCAL_FORMATTED]=factor_arpul
      data_formatted[REVENUE_LOCAL_FORMATTED]=factor_rl
      data_formatted[NET_REVENUE_LOCAL_FORMATTED]=factor_nrl
      data_formatted[MEDIA_COST_LOCAL_FORMATTED]=factor_mdcl

      #stats
      data_formatted[SUBSCRIBERS_SHORT]=subscribers
      data_formatted[ACTIVE_SUBSCRIBERS_SHORT]=active_subscribers
      data_formatted[UN_SUBSCRIPTIONS_SHORT]=un_subcriptions
      data_formatted[VALID_SUBSCRIPTIONS_SHORT]=valid_subscriptions
      data_formatted[LANDING_PAGE_VIEWS_SHORT]=lpv
      data_formatted[ENGAGMENTS_SHORT]=e
      data_formatted[BANNER_CLICKS_SHORT]=bc
      data_formatted[INVALID_SUBSCRIPTIONS_SHORT]=isup
      data_formatted[INVALID_LANDING_PAGE_VIEWS_SHORT]=ilpv
      data_formatted[INVALID_ENGAGMENTS_SHORT]=ie
      data_formatted[MT_SENT_SHORT]=mts
      data_formatted[MT_SUCCESS_SHORT]=mtss
      data_formatted[MT_SENT_BY_OPERATOR_SHORT]=mtso
      data_formatted[AVERAGE_REVENUE_PER_SUBSCRIBER_LOCAL_SHORT]=arpul
      data_formatted[REVENUE_LOCAL_SHORT]=rl
      data_formatted[NET_REVENUE_LOCAL_SHORT]=nl
      data_formatted[MEDIA_COST_LOCAL_SHORT]=mcl

      data_formatted[GRAPH_ID_SHORT]=graph_ids
      data_formatted[NEW_SUB_UNSUB_PERCENT_SHORT]=nsup
      data_formatted[MT_SUCCESS_PERCENT_SHORT]=mssp

      response[DATA]=data_formatted

      response[CURRENCY]=CURRENCY_SYMBOL[@auth_token[CURRENCY_ID]]
      render :json => response, :status => response[STATUS_CODE]
    rescue Exception => e
      puts e.message,e.backtrace
      exception_job = {:controller_action => "campaign_graph", :exception => e.message ,
                       :backtrace => e.backtrace.inspect}
      Resque.enqueue(ExceptionLogJob,exception_job)
      response = EXCEPTION.dup
      render :json => response, :status => response[EXCEPTION]
    end
  end



  def media
    begin
      now=DateUtility.getUtcStartDateFromDate(Time.now.utc())
      response = SUCCESS.dup
      response[CURRENCY]=CURRENCY_SYMBOL[@auth_token[CURRENCY_ID]]
      response[DATA] = Campaign::MediaLifetime.list(params[:id],now)
      render :json => response, :status => response[STATUS_CODE]
    rescue Exception => e
      puts e,e.backtrace
      exception_job = {:controller_action => "media_performance", :exception => e.message ,
                       :backtrace => e.backtrace.inspect}
      Resque.enqueue(ExceptionLogJob,exception_job)
      response = EXCEPTION.dup
      render :json => response, :status => response[EXCEPTION]
    end
  end

  def operator
    begin
      now=DateUtility.getUtcStartDateFromDate(Time.now.utc())
      response = SUCCESS.dup
      response[DATA] = Campaign::OperatorLifetime.list(params[:id],now)
      response[CURRENCY]=CURRENCY_SYMBOL[@auth_token[CURRENCY_ID]]
      render :json => response, :status => response[STATUS_CODE]
    rescue Exception => e
      exception_job = {:controller_action => "operator_performance", :exception => e.message ,
                       :backtrace => e.backtrace.inspect, }
      Resque.enqueue(ExceptionLogJob,exception_job)
      response = EXCEPTION.dup
      render :json => response, :status => response[EXCEPTION]
    end
  end

end