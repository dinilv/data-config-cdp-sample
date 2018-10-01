class V1::ContentProviders::ContentProviderController < ApplicationController
  before_action :parse_request_creation, :only => :create
  before_action :authorize, :only => [:update, :show, :dashboard]

  def list
    begin
      response = SUCCESS.dup
      limit, offset, order, search, sort = Config::RequestService.get_list_parameters(params)
      response[COUNT] = ContentProvider.content_provider_count(search)
      response[DATA] = ContentProvider.listing(search, offset, limit, sort, order)
      content_provider_data = []
      response[DATA].each do |content_provider|
        db = {}
        Contentprovider.each do |k, v|
          db[v] = content_provider[v]
        end
        db[COUNTRY] = COUNTRY_MAP[content_provider[COUNTRY_ID]]
        if content_provider[CAMPANY_ID] == nil
          db[COMPANY_NAME] = ""
        else
          db[COMPANY_NAME] = content_provider[CAMPANY_ID]
        end
        content_provider_data.push(db)
      end
      response[DATA]=content_provider_data

      render :json => response, :status => response[STATUS_CODE]
    rescue Exception => e
      exception_job = {:controller_action => "campaign_list", :exception => e.message,
                       :backtrace => e.backtrace.inspect,:version=>"v1"}
      Resque.enqueue(ExceptionLogJob, exception_job)
      response = EXCEPTION.dup
      render :json => response, :status => response[EXCEPTION]
    end
  end

  def create
    begin
      status, message = @@content_provider_service.create_content_provider(params, request.remote_ip)
      if status == false && message == 'Required fields are missing.'
        response = GlobalResponseConstants::UNPROCESSABLE.dup
        response[GlobalResponseConstants::MESSAGE] = message
        render :json => response, :status => response[GlobalResponseConstants::STATUS_CODE]
      elsif status == true && message == 'Success'
        response = GlobalResponseConstants::SUCCESS.dup
        response[GlobalResponseConstants::MESSAGE] = "Please go to mail and verify"
        render :json => response, :status => response[GlobalResponseConstants::STATUS_CODE]
      elsif status == false
        response = GlobalResponseConstants::BAD_REQUEST.dup
        response[GlobalResponseConstants::MESSAGE] = message
        render :json => response, :status => response[GlobalResponseConstants::STATUS_CODE]
      end
    rescue Exception => e
      puts e
      exception_job = {:controller_action => "content_provider_create", :exception => e.message, :backtrace => e.backtrace.inspect,:version=>"v1"}
      Resque.enqueue(ExceptionLogJob, exception_job)
      response = GlobalResponseConstants::EXCEPTION.dup
      render :json => response, :status => response[GlobalResponseConstants::EXCEPTION]
    end
  end

  def update
    begin
      unless @@content_provider_service.update_content_provider(params, @auth_token, request.remote_ip)
        response = GlobalResponseConstants::UNPROCESSABLE.dup
        render :json => response, :status => response[GlobalResponseConstants::STATUS_CODE]
      else
        response = GlobalResponseConstants::SUCCESS.dup
        render :json => response, :status => response[GlobalResponseConstants::STATUS_CODE]
      end
    rescue Exception => e
      exception_job = {:controller_action => "content_provider_update", :exception => e.message, :backtrace => e.backtrace.inspect, :version=>"v1"}
      Resque.enqueue(ExceptionLogJob, exception_job)
      response = GlobalResponseConstants::EXCEPTION.dup
      render :json => response, :status => response[GlobalResponseConstants::EXCEPTION]
    end
  end

  def dashboard
    begin
      status, data = @@content_provider_service.dashboard
      unless status
        response = GlobalResponseConstants::EXCEPTION.dup
        render :json => response, :status => response[GlobalResponseConstants::STATUS_CODE]
      else
        response = GlobalResponseConstants::SUCCESS.dup
        response[GlobalResponseConstants::DATA] = data
        render :json => response, :status => response[GlobalResponseConstants::STATUS_CODE]
      end
    rescue Exception => e
      exception_job = {:controller_action => "content_provider_dashboard", :exception => e.message, :backtrace => e.backtrace.inspect, :version=>"v1"}
      Resque.enqueue(ExceptionLogJob, exception_job)
      response = GlobalResponseConstants::EXCEPTION.dup
      render :json => response, :status => response[GlobalResponseConstants::EXCEPTION]
    end
  end

  def parse_request_creation
    unless params.has_key?(:email) && params.has_key?(:password) && params.has_key?(:first_name) && params.has_key?(:last_name) && params.has_key?(:contact)
      response = GlobalResponseConstants::NOT_ACCEPTABLE.dup
      response[GlobalResponseConstants::MESSAGE] = 'Required field missing'
      render :json => response, :status => response[GlobalResponseConstants::STATUS_CODE]
    end
  end

  def show
    begin
      status, data = @@content_provider_service.show_content_provider(params)
      if status
        response = SUCCESS.dup
        response[DATA] = data
        render :json => response, :status => response[STATUS_CODE]
      elsif !status && data == "exception"
        response = EXCEPTION.dup
        render :json => response, :status => response[STATUS_CODE]
      else
        response = REQUEST_INVALID.dup
        response[MESSAGE] = data
        render :json => response, :status => response[STATUS_CODE]
      end
    rescue Exception => e
      exception_job = {:controller_action => "content_provider_show", :exception => e.message , :backtrace => e.backtrace.inspect, :version=>"v1"}
      Resque.enqueue(ExceptionLogJob,exception_job)
      response = EXCEPTION.dup
      render :json => response, :status => response[EXCEPTION]
    end
  end

end
