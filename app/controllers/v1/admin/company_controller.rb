class V1::Admin::CompanyController <  ApplicationController
  before_action :admin_authorize, :only => [:create,:list]
  def create
    begin
      status,message = @@company_service.create_company(params,request.remote_ip)
      if status == false && message == 'Required fields are missing.'
        response = GlobalResponseConstants::UNPROCESSABLE.dup
        response[GlobalResponseConstants::MESSAGE] = message
        render :json => response, :status => response[GlobalResponseConstants::STATUS_CODE]
      elsif status == true && message == 'Success'
        response = GlobalResponseConstants::SUCCESS.dup
        response[GlobalResponseConstants::MESSAGE] = "Account successfully Created"
        render :json => response, :status => response[GlobalResponseConstants::STATUS_CODE]
      elsif status == false
        response = GlobalResponseConstants::BAD_REQUEST.dup
        response[GlobalResponseConstants::MESSAGE] = message
        render :json => response, :status => response[GlobalResponseConstants::STATUS_CODE]
      end
    rescue Exception => e
      puts e
      exception_job = {:controller_action => "content_provider_create", :exception => e.message , :backtrace => e.backtrace.inspect, :version=>"v1"}
      Resque.enqueue(ExceptionLogJob,exception_job)
      response = GlobalResponseConstants::EXCEPTION.dup
      render :json => response, :status => response[GlobalResponseConstants::EXCEPTION]
    end
  end

  def list
    begin
      response = SUCCESS.dup
      limit, offset, order, search, sort = Config::RequestService.get_list_parameters(params)
      response[COUNT] = Company.company_count(search)
      response[DATA] = Company.listing(search, offset, limit, sort, order)
      content_data = []
      response[DATA].each do |company_data|
        db = {}
        Company_Hash.each do |k, v|
          db[v] = company_data[v]
        end
        db[COUNTRY] = COUNTRY_MAP[company_data[COUNTRY_ID]]
        db[STATUS] = STATUS_MAP[company_data[STATUS]]
        content_data.push(db)
      end
      response[DATA]=content_data
      render :json => response, :status => response[STATUS_CODE]
    rescue Exception => e
      exception_job = {:controller_action => "campaign_list", :exception => e.message,
                       :backtrace => e.backtrace.inspect, :version=>"v1"}
      Resque.enqueue(ExceptionLogJob, exception_job)
      response = EXCEPTION.dup
      render :json => response, :status => response[EXCEPTION]
    end
  end
end