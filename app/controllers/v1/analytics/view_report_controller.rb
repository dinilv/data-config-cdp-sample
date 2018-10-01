class V1::Analytics::ViewReportController < ApplicationController
  before_action :authorize, :only => [:campaign_traffic,:campaign_monetize,:media_monetize,:operator_monetize,:msisdn]

    def campaign_traffic
        begin
            response = SUCCESS.dup
            response[CURRENCY]=CURRENCY_SYMBOL[@auth_token[CURRENCY_ID]]

            report_request={}
            report_request[COMPANY_ID_SHORT]=@auth_token[COMPANY_ID]
            report_request[CURRENCY]=CURRENCY_SYMBOL[@auth_token[CURRENCY_ID]]
            @@request_service.get_view_report_parameters(params,report_request)

            response[COUNT]=Campaign::MediaDaily.get_count_campaign_media_traffic(report_request)
            response[DATA]=Campaign::MediaDaily.get_campaign_media_traffic_report(report_request)
            response[TOTAL]=Campaign::MediaDaily.get_total_report(report_request)

            render :json => response, :status => response[STATUS_CODE]
        rescue Exception => e
          puts e, e.backtrace
            exception_job = {:controller_action => "view_media_traffic", :exception => e.message , :backtrace => e.backtrace.inspect}
            Resque.enqueue(ExceptionLogJob,exception_job)
            response = EXCEPTION.dup
            render :json => response, :status => response[EXCEPTION]
        end
    end

    def campaign_monetize
        begin
            response = SUCCESS.dup
            response[CURRENCY]=CURRENCY_SYMBOL[@auth_token[CURRENCY_ID]]
            report_request={}
            report_request[COMPANY_ID_SHORT]=@auth_token[COMPANY_ID]
            report_request[CURRENCY]=CURRENCY_SYMBOL[@auth_token[CURRENCY_ID]]
            @@request_service.get_view_report_parameters(params,report_request)

            response[COUNT]=Campaign::SummaryDaily.get_count_campaign_monetize(report_request)
            response[DATA]=Campaign::SummaryDaily.get_campaign_monetize_report(report_request)
            response[TOTAL]=Campaign::SummaryDaily.get_total_report(report_request)

            render :json => response, :status => response[STATUS_CODE]
        rescue Exception => e
            exception_job = {:controller_action => "view_campaign_monetize", :exception => e.message , :backtrace => e.backtrace.inspect}
            Resque.enqueue(ExceptionLogJob,exception_job)
            response = EXCEPTION.dup
            render :json => response, :status => response[EXCEPTION]
        end
    end

    def media_monetize
        begin
            response = SUCCESS.dup
            response[CURRENCY]=CURRENCY_SYMBOL[@auth_token[CURRENCY_ID]]

            report_request={}
            report_request[COMPANY_ID_SHORT]=@auth_token[COMPANY_ID]
            report_request[CURRENCY]=CURRENCY_SYMBOL[@auth_token[CURRENCY_ID]]
            @@request_service.get_view_report_parameters(params,report_request)

            response[COUNT]=Account::MediaDaily.get_count_media_monetize(report_request)
            response[DATA]=Account::MediaDaily.get_media_monetize_report(report_request)
            response[TOTAL]=Account::MediaDaily.get_total_report(report_request)

            render :json => response, :status => response[STATUS_CODE]
        rescue Exception => e
            exception_job = {:controller_action => "view_media_monetize", :exception => e.message , :backtrace => e.backtrace.inspect}
            Resque.enqueue(ExceptionLogJob,exception_job)
            response = EXCEPTION.dup
            render :json => response, :status => response[EXCEPTION]
        end
    end

    def operator_monetize
      begin
        response = SUCCESS.dup
        response[CURRENCY]=CURRENCY_SYMBOL[@auth_token[CURRENCY_ID]]

        report_request={}
        report_request[COMPANY_ID_SHORT]=@auth_token[COMPANY_ID]
        report_request[CURRENCY]=CURRENCY_SYMBOL[@auth_token[CURRENCY_ID]]
        @@request_service.get_view_report_parameters(params,report_request)

        response[COUNT]=Account::OperatorDaily.get_count_operator_monetize(report_request)
        response[DATA]=Account::OperatorDaily.get_operator_monetize_report(report_request)
        response[TOTAL]=Account::OperatorDaily.get_total_report(report_request)

        render :json => response, :status => response[STATUS_CODE]
      rescue Exception => e
        exception_job = {:controller_action => "view_operator_monetize", :exception => e.message , :backtrace => e.backtrace.inspect}
        Resque.enqueue(ExceptionLogJob,exception_job)
        response = EXCEPTION.dup
        render :json => response, :status => response[EXCEPTION]
      end
    end

    def msisdn
      begin
        response = SUCCESS.dup
        response[CURRENCY]=CURRENCY_SYMBOL[@auth_token[CURRENCY_ID]]

        report_request={}
        report_request[COMPANY_ID_SHORT]=@auth_token[COMPANY_ID]
        report_request[CURRENCY]=CURRENCY_SYMBOL[@auth_token[CURRENCY_ID]]
        @@request_service.get_view_report_parameters(params,report_request)

        response[COUNT]=Msisdn::Lifetime.get_count_report(report_request)
        response[DATA]=Msisdn::Lifetime.get_view_report(report_request)
        response[TOTAL]=Msisdn::Lifetime.get_total_report(report_request)

        render :json => response, :status => response[STATUS_CODE]
      rescue Exception => e
        puts e,e.backtrace
        exception_job = {:controller_action => "view_msisdn", :exception => e.message , :backtrace => e.backtrace.inspect}
        Resque.enqueue(ExceptionLogJob,exception_job)
        response = EXCEPTION.dup
        render :json => response, :status => response[EXCEPTION]
      end
    end
  end
