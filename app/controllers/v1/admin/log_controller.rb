class V1::Admin::LogController <  ApplicationController


#exception log
  def exception_list
    begin
      formatted_date=DateUtility.getUtcStartDateFromDate(Time.now.utc())
      response = SUCCESS.dup
      search=@@request_service.get_exception_parameters(params)
      response[DATA] = ExceptionLog.listing(search,"desc")
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





end