class V1::Analytics::DownloadReportController < ApplicationController
    require "action_dispatch/http/response"
    before_action :authorize, :only => [:campaign_traffic, :campaign_monetize, :media_monetize, :operator_monetize,:msisdn]
    before_action :token_renew, :only => [:campaign_traffic, :campaign_monetize, :media_monetize, :operator_monetize,:msisdn]

    def campaign_traffic
        begin
          filename = Time.now.strftime('%Y%m%d%H%M%S%L')
          filepath = "reports/campaign_traffic_report_"+filename+".csv"

          currency=CURRENCY_SYMBOL[@auth_token[CURRENCY_ID]]
          report_request={}
          report_request[COMPANY_ID_SHORT]=@auth_token[COMPANY_ID]
          headers=_replace_currency_headers(currency,CAMPAIGN_TRAFFIC_HEADERS.dup)
          @@request_service.get_download_report_parameters(params,report_request)

          reports=Campaign::MediaDaily.get_download_report(report_request)
          totals=Campaign::MediaDaily.get_csv_total_report(report_request)

          _writeToCSV(filepath,headers,CAMPAIGN_TRAFFIC_FIELDS,totals,reports)

          f = File.open("#{filepath}", "r")

          response.set_header('Access-Control-Expose-Headers','File-Name')
          response.set_header('File-Name',"campaign_traffic_report_#{filename}.csv")
          #send_file_headers!
          send_file(f, :type=>"application/csv", :chunked=> true)

          puts response
        rescue Exception => e
          puts e,e.backtrace
          exception_job = {:controller_action => "download_media_traffic", :exception => e.message , :backtrace => e.backtrace.inspect}
          Resque.enqueue(ExceptionLogJob,exception_job)
          response = GlobalResponseConstants::EXCEPTION.dup
          render :json => response, :status => response[GlobalResponseConstants::EXCEPTION]
        end
    end

    def campaign_monetize
      begin
        filename = Time.now.strftime('%Y%m%d%H%M%S%L')
        filepath = "reports/campaign_monetize_report_"+filename+".csv"
        currency=CURRENCY_SYMBOL[@auth_token[CURRENCY_ID]]
        headers=_replace_currency_headers(currency,CAMPAIGN_MONETIZATION_HEADERS.dup)
        report_request={}
        report_request[COMPANY_ID_SHORT]=@auth_token[COMPANY_ID]
        @@request_service.get_download_report_parameters(params,report_request)

        reports=Campaign::SummaryDaily.get_download_report(report_request)
        totals=Campaign::SummaryDaily.get_csv_total_report(report_request)

        _writeToCSV(filepath,headers,CAMPAIGN_MONETIZATION_FIELDS,totals,reports)

        f = File.open("#{filepath}", "r")
        response.headers['Access-Control-Expose-Headers']='File-Name'
        response.headers['File-Name'] ="campaign_monetize_report_#{filename}.csv"
        send_file f, :type=>"application/csv", :chunked=> true
      rescue Exception => e
        puts e,e.backtrace
        exception_job = {:controller_action => "download_media_traffic", :exception => e.message , :backtrace => e.backtrace.inspect}
        Resque.enqueue(ExceptionLogJob,exception_job)
        response = GlobalResponseConstants::EXCEPTION.dup
        render :json => response, :status => response[GlobalResponseConstants::EXCEPTION]
      end
    end

    def media_monetize
      begin
        filename = Time.now.strftime('%Y%m%d%H%M%S%L')
        filepath = "reports/media_monetize_report_"+filename+".csv"
        currency=CURRENCY_SYMBOL[@auth_token[CURRENCY_ID]]
        headers=_replace_currency_headers(currency,MEDIA_MONETIZATION_HEADERS.dup)

        report_request={}
        report_request[COMPANY_ID_SHORT]=@auth_token[COMPANY_ID]
        @@request_service.get_download_report_parameters(params,report_request)

        reports=Account::MediaDaily.get_download_report(report_request)
        totals=Account::MediaDaily.get_csv_total_report(report_request)

        _writeToCSV(filepath,headers,MEDIA_MONETIZATION_FIELDS,totals,reports)

        f = File.open("#{filepath}", "r")
        response.headers['Access-Control-Expose-Headers']='File-Name'
        response.headers['File-Name'] ="media_monetize_report_#{filename}.csv"
        send_file f, :type=>"application/csv", :chunked=> true
      rescue Exception => e
        puts e,e.backtrace
        exception_job = {:controller_action => "download_media_traffic", :exception => e.message , :backtrace => e.backtrace.inspect}
        Resque.enqueue(ExceptionLogJob,exception_job)
        response = GlobalResponseConstants::EXCEPTION.dup
        render :json => response, :status => response[GlobalResponseConstants::EXCEPTION]
      end
    end

    def operator_monetize
      filename = Time.now.strftime('%Y%m%d%H%M%S%L')
      filepath = "reports/operator_monetize_report_"+filename+".csv"
      currency=CURRENCY_SYMBOL[@auth_token[CURRENCY_ID]]
      headers=_replace_currency_headers(currency,OPERATOR_MONETIZATION_HEADERS.dup)

      report_request={}
      report_request[COMPANY_ID_SHORT]=@auth_token[COMPANY_ID]
      @@request_service.get_download_report_parameters(params,report_request)

      reports=Account::MediaDaily.get_download_report(report_request)
      totals=Account::MediaDaily.get_csv_total_report(report_request)

      _writeToCSV(filepath,headers,OPERATOR_MONETIZATION_FIELDS,totals,reports)

      f = File.open("#{filepath}", "r")
      response.headers['Access-Control-Expose-Headers']='File-Name'
      response.headers['File-Name'] ="operator_monetize_report_#{filename}.csv"
      send_file f, :type=>"application/csv", :chunked=> true
    rescue Exception => e
      puts e,e.backtrace
      exception_job = {:controller_action => "download_media_traffic", :exception => e.message , :backtrace => e.backtrace.inspect}
      Resque.enqueue(ExceptionLogJob,exception_job)
      response = GlobalResponseConstants::EXCEPTION.dup
      render :json => response, :status => response[GlobalResponseConstants::EXCEPTION]
    end

    def msisdn
        begin
          filename = Time.now.strftime('%Y%m%d%H%M%S%L')
          filepath = "reports/msisdn_report_"+filename+".csv"
          currency=CURRENCY_SYMBOL[@auth_token[CURRENCY_ID]]
          headers=_replace_currency_headers(currency,MSISDN_REPORT_HEADERS.dup)

          report_request={}
          report_request[COMPANY_ID_SHORT]=@auth_token[COMPANY_ID]
          @@request_service.get_download_report_parameters(params,report_request)

          reports=Msisdn::Lifetime.get_download_report(report_request)
          totals=1


          _writeToCSV(filepath,headers,MSISDN_REPORT_FIELDS,totals,reports)

          f = File.open("#{filepath}", "r")
          response.headers['Access-Control-Expose-Headers']='File-Name'
          response.headers['File-Name'] ="msisdn_report_#{filename}.csv"
          send_file f, :type=>"application/csv", :chunked=> true
        rescue Exception => e
            puts e, e.backtrace
            exception_job = {:controller_action => "download_msisdn", :exception => e.message , :backtrace => e.backtrace.inspect}
            Resque.enqueue(ExceptionLogJob,exception_job)
            response = GlobalResponseConstants::EXCEPTION.dup
            render :json => response, :status => response[GlobalResponseConstants::EXCEPTION]
        end
    end

    private
        def _writeToCSV(filename,headers,fields,totals,report)
            CSV.open("#{filename}", "wb") do |csv|
                #add header with currency
                csv << headers
                for data in report
                    dataArray=[]
                    fields.each do |key|
                      datarow=""
                      splitted=key.split(".")

                      if splitted.length> 1
                        datarow=data[ID_][splitted[1]]
                      else
                        datarow=data[key]
                      end
                        #individual data elements
                        dataArray.push(datarow)
                    end
                    #write all elements atonce
                    csv << dataArray
                end
                #write totals
                csv << totals
            end
        end

  def _replace_currency_headers(currency,headers)
    new_headers=[]
    headers.each do |header|
      header.gsub! '<currency>', currency
      new_headers.push(header)
    end
    return new_headers
  end

end

