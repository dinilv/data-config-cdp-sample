class V1::Analytics::CustomReportController < ApplicationController
  before_action :authorize, :only => [:view,:download]

    def view
        begin
            response = GlobalResponseConstants::SUCCESS.dup
            response[GlobalResponseConstants::DATA] = @@content_provider_service.show_content_provider(params)
            render :json => response, :status => response[GlobalResponseConstants::STATUS_CODE]
        rescue Exception => e
            puts "User show = #{e}", e.backtrace
            exception_job = {:controller_action => "content_provider_show", :exception => e.message , :backtrace => e.backtrace.inspect, :version=>"v1"}
            Resque.enqueue(ExceptionLogJob,exception_job)
            response = GlobalResponseConstants::EXCEPTION.dup
            render :json => response, :status => response[GlobalResponseConstants::EXCEPTION]
        end
    end

    def download
        begin
            response = GlobalResponseConstants::SUCCESS.dup
            response[GlobalResponseConstants::DATA] = @@content_provider_service.show_content_provider(params)
            render :json => response, :status => response[GlobalResponseConstants::STATUS_CODE]
        rescue Exception => e
            puts "User show = #{e}", e.backtrace
            exception_job = {:controller_action => "content_provider_show", :exception => e.message , :backtrace => e.backtrace.inspect,:version=>"v1"}
            Resque.enqueue(ExceptionLogJob,exception_job)
            response = GlobalResponseConstants::EXCEPTION.dup
            render :json => response, :status => response[GlobalResponseConstants::EXCEPTION]
        end
    end
  end
