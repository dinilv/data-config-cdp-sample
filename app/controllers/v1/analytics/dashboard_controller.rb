class V1::Analytics::DashboardController < ApplicationController
    before_action :authorize, :only => [:graph,:lifetime,:current,:active]
    before_action :token_renew, :only => [:graph]
    def graph
        begin
            now=Time.now.utc
            cy_id=@auth_token[COMPANY_ID]
            response =SUCCESS.dup
            start_date=DateUtility.getUtcStartDateFromDateAndDays(now,29)
            end_date=DateUtility.getUtcStartDateFromDateAndDays(now,0)

            #default data
            max_sub,max_arpul,max_asub,max_usub,max_vsup,max_nsup,max_rl,max_nrl,max_mdcl=0,0,0,0,0,0,0,0,0
            factor_sub,factor_nsub,factor_arpul,factor_asub,factor_usub,factor_vsup,factor_rl,factor_nrl,factor_mdcl=ONE,ONE,ONE,ONE,ONE,ONE,ONE,ONE,ONE,ONE
            graph_ids,subscribers,active_subscribers,un_subcriptions,arpul,valid_subscriptions,mssp,rl,nrl,mcl,nsup=[],[],[],[],[],[],[],[],[],[],[],[],[],[],[]

            #query
            unformatted_data= Account::SummaryDaily.graph(cy_id,start_date,end_date)
            max_values_graph=Account::SummaryDaily.max_value_graph(cy_id,start_date,end_date)
            left_axis_max_value=100
            right_axis_max_value=10
            #assign max values
            max_values_graph.each do |each_data|
              factor_asub=ApiUtility.find_factor(each_data[ASUB_MAX])
              factor_usub=ApiUtility.find_factor(each_data[USUP_MAX])
              factor_sub=ApiUtility.find_factor(each_data[SUB_MAX])
              factor_nsub=ApiUtility.find_factor(each_data[NSUP_MAX])
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
          puts e.backtrace
            exception_job = {:controller_action => "dashboard_graph", :exception => e.message , :backtrace => e.backtrace.inspect, :version=>"v1"}
            Resque.enqueue(ExceptionLogJob,exception_job)
            response = EXCEPTION.dup
            render :json => response, :status => response[EXCEPTION]
        end
    end

    def lifetime
        begin
            response = SUCCESS.dup
            data= Account::SummaryLifetime.lifetime(@auth_token[COMPANY_ID],
                                                    DateUtility.getUtcStartDateFromDateAndDays(Time.now.utc(),0))
            response[DATA] = data[0]
            response[CURRENCY]=CURRENCY_SYMBOL[@auth_token[CURRENCY_ID]]

            render :json => response, :status => response[STATUS_CODE]
        rescue Exception => e
            exception_job = {:controller_action => "dashbaord_account_monetization", :exception => e.message , :backtrace => e.backtrace.inspect, :version=>"v1"}
            Resque.enqueue(ExceptionLogJob,exception_job)
            response = EXCEPTION.dup
            render :json => response, :status => response[EXCEPTION]
        end
    end

    def current
        begin
            response = SUCCESS.dup

            data=Account::SummaryDaily.current(@auth_token[COMPANY_ID],

                                                           DateUtility.getUtcStartDateFromDateAndDays(Time.now.utc(),0))
            data.each do  |obj|
              obj['sub']=ActiveSupport::NumberHelper.number_to_delimited(obj['sub'])
              obj['asub']=ActiveSupport::NumberHelper.number_to_delimited(obj['asub'])
              response[DATA] = obj
            end
            response[CURRENCY]=CURRENCY_SYMBOL[@auth_token[CURRENCY_ID]]

            render :json => response, :status => response[STATUS_CODE]
        rescue Exception => e
          puts e.backtrace
            exception_job = {:controller_action => "current_performance", :exception => e.message , :backtrace => e.backtrace.inspect, :version=>"v1"}
            Resque.enqueue(ExceptionLogJob,exception_job)
            response = EXCEPTION.dup
            render :json => response, :status => response[EXCEPTION]
        end
    end

    def active
        begin
            response = SUCCESS.dup
            sort="active_subscribers"
            if params[:sort]
                sort=params[:sort]
            end

            data= Campaign::SummaryThirty.active(@auth_token[COMPANY_ID],
                                                 DateUtility.getUtcStartDateFromDateAndDays(Time.now.utc(),0),sort)
            response[DATA] = data
            response[CURRENCY]=CURRENCY_SYMBOL[@auth_token[CURRENCY_ID]]

            render :json => response, :status => response[STATUS_CODE]
        rescue Exception => e
            exception_job = {:controller_action => "top_30_campaigns", :exception => e.message , :backtrace => e.backtrace.inspect, :version=>"v1"}
            Resque.enqueue(ExceptionLogJob,exception_job)
            response = EXCEPTION.dup
            render :json => response, :status => response[EXCEPTION]
        end

    end



  end
