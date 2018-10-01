class V1::Migration::ApiMigrationController <  ApplicationController

  def campaign_create
    begin
      status, message = @@migration_service.create_campaign_migration(params)
      unless status
        response = GlobalResponseConstants::REQUEST_INVALID.dup
        response[GlobalResponseConstants::MESSAGE] = message
        render :json => response, :status => response[GlobalResponseConstants::STATUS_CODE]
      else
        response = GlobalResponseConstants::SUCCESS.dup
        render :json => response, :status => response[GlobalResponseConstants::STATUS_CODE]
      end
    rescue Exception => e
      puts "Campaign List = #{e}"
      exception_job = {:controller_action => "campaign_create", :exception => e.message , :backtrace => e.backtrace.inspect,:version=>"v1"}
      Resque.enqueue(ExceptionLogJob,exception_job)
      response = GlobalResponseConstants::EXCEPTION.dup
      render :json => response, :status => response[GlobalResponseConstants::EXCEPTION]
    end
  end



  def media
    begin
      unless  params.has_key?(:media_template) && params.has_key?(:media_name)
        response = GlobalResponseConstants::NOT_ACCEPTABLE.dup
        render :json => response, :status => response[GlobalResponseConstants::STATUS_CODE]
      else
        status,message = @@migration_service.create_media(params)
        unless status
          response = GlobalResponseConstants::EXCEPTION.dup
          render :json => response, :status => response[GlobalResponseConstants::STATUS_CODE]
        else
          response = GlobalResponseConstants::SUCCESS.dup
          render :json => response, :status => response[GlobalResponseConstants::STATUS_CODE]
        end
      end
    rescue Exception => e
      exception_job = {:controller_action => "admin_create_media_controller", :exception => e.message, :backtrace => e.backtrace.inspect, :version=>"v1"}
      Resque.enqueue(ExceptionLogJob,exception_job)
      response = GlobalResponseConstants::EXCEPTION.dup
      render :json => response, :status => response[GlobalResponseConstants::STATUS_CODE]
    end
  end


  def advertiser
    begin
      status,message =@@migration_service.create_content_provider(params)
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
      puts "User Create EXCEPTION = #{e}"
      exception_job = {:controller_action => "content_provider_create", :exception => e.message , :backtrace => e.backtrace.inspect, :version=>"v1"}
      Resque.enqueue(ExceptionLogJob,exception_job)
      response = GlobalResponseConstants::EXCEPTION.dup
      render :json => response, :status => response[GlobalResponseConstants::EXCEPTION]
    end
  end




end
