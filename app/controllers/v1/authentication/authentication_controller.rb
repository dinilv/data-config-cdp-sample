class V1::Authentication::AuthenticationController < ApplicationController

  before_action :authorize, :only => [:update_password,:log_out]
  def log_in
    begin
        status, message = @@auth_service.log_in(params,request.remote_ip)
      unless status
        response = GlobalResponseConstants::REQUEST_INVALID.dup
        render :json => message, :status => response[GlobalResponseConstants::STATUS_CODE]
      else
        response = GlobalResponseConstants::SUCCESS.dup
        response = message
        render :json => message, :status => response[GlobalResponseConstants::STATUS_CODE]
      end
    rescue Exception => e
      exception_job = {:controller_action => "login", :exception => e.message , :backtrace => e.backtrace.inspect}
      Resque.enqueue(ExceptionLogJob,exception_job)
      response = GlobalResponseConstants::EXCEPTION.dup
      render :json => response, :status => response[GlobalResponseConstants::EXCEPTION]
    end
  end
  def update_password
    begin
      unless params.has_key?(:old_password) && params.has_key?(:new_password) && params.has_key?(:confirm_password)
        response = NOT_ACCEPTABLE.dup
        render :json => response, :status => response[STATUS_CODE]
      else
        member = Member.where(email: @auth_token['email'])[0]
        old_password = Digest::SHA2.hexdigest(member.password_salt + params[:old_password])
        unless old_password == member.password
          response = REQUEST_INVALID.dup
          response[MESSAGE] = 'Old password entered is wrong'
          render :json => response, :status => response[STATUS_CODE]
        else
          new_password = Digest::SHA2.hexdigest(member.password_salt + params[:new_password])
          member.update(password: new_password)
          activity = {:updated_by => member.email, :role => member.role, :member_id => member.member_id, :activity => "Password Update", :version=>"v1"}
          Resque.enqueue(AccessLog, activity)
          response = SUCCESS.dup
          response[MESSAGE] = 'Password Changed Successfully'
          render :json => response, :status => response[STATUS_CODE]
        end
      end
    rescue Exception => e
      exception_job = {:controller_action => "content_provider_change_password", :exception => e.message, :backtrace => e.backtrace.inspect, :version=>"v1"}
      Resque.enqueue(ExceptionLogJob, exception_job)
      response = EXCEPTION.dup
      render :json => response, :status => response[EXCEPTION]
    end
  end


  def log_out
    response = {}
    response = @@new_response.success
    token =@auth_token['token']

    #invalidate tokenre
    render :json => response, :status => response[STATUS_CODE]
  end

  def forgot_password
    begin
      if params.has_key?(:email) && RegexValidation.email_validate(params[:email]) == 0 && Member.where(email: params[:email].downcase).exists?
        member = Member.where(email: params[:email].downcase)[0]
        member.update(token: SecureRandom.hex(8))
        content_provider = ContentProvider.where(email: member.email)[0]
        link = "http://104.198.98.165:8082/reset-password?token=" + member.token
        mail_info = {"recipients" => member.email, "subject" => "Password reset", "link" => link, "first_name" => content_provider.first_name}
        obj = Resque.enqueue(MailingJob, mail_info, 2)
        activity = {:updated_by => member.email, :role => member.role, :member_id => member.member_id, :activity => "Forgot password", :version=>"v1"}
        Resque.enqueue(ActivityLoggerJob, activity)
        response = SUCCESS.dup
        response[MESSAGE] = "Please check your registered email address"
        render :json => response, :status => response[STATUS_CODE]
      elsif params.has_key?(:email) && RegexValidation.email_validate(params[:email]) == 0 && !Member.where(email: params[:email]).exists?
        response = REQUEST_INVALID.dup
        response[MESSAGE] = 'Account does not exist'
        render :json => response, :status => response[STATUS_CODE]
      elsif params.has_key?(:email) && RegexValidation.email_validate(params[:email]) != 0
        response = REQUEST_INVALID.dup
        response[MESSAGE] = 'Invalid email ID'
        render :json => response, :status => response[STATUS_CODE]
      else
        response = NOT_ACCEPTABLE.dup
        response[MESSAGE] = 'Please enter your email ID'
        render :json => response, :status => response[STATUS_CODE]
      end
    rescue Exception => e
      exception_job = {:controller_action => "forgot_password_exception", :exception => e.message, :backtrace => e.backtrace.inspect, :version=>"v1"}
      Resque.enqueue(ExceptionLogJob, exception_job)
      render :json => EXCEPTION, :status => RESP_ERROR_CODE
    end
  end

  def reset_password
    begin
      if params.has_key?(:token) && Member.where(token: params[:token]).exists? && params.has_key?(:password) && params.has_key?(:confirm_password) && params[:password] == params[:confirm_password]
        member = Member.where(token: params[:token])[0]
        password = Digest::SHA2.hexdigest(member['password_salt'] + params[:password])
        member.update(password: password)
        activity = {:updated_by => member.email, :role => member.role, :member_id => member.member_id, :activity => "Password Reset", :version=>"v1"}
        Resque.enqueue(ActivityLoggerJob, activity)
        response = SUCCESS.dup
        response[MESSAGE] = 'Password Changed Successfully'
        render :json => response, :status => response[STATUS_CODE]
      elsif params.has_key?(:token) && params.has_key?(:password) && params.has_key?(:confirm_password) && params[:password] != params[:confirm_password] && Member.where(token: params[:token]).exists?
        response = BAD_REQUEST.dup
        response[MESSAGE] = 'Passwords do not match'
        render :json => response, :status => response[STATUS_CODE]
      elsif params.has_key?(:token) && params.has_key?(:password) && params.has_key?(:confirm_password) && params[:password] == params[:confirm_password] && !Member.where(token: params[:token]).exists?
        response = REQUEST_INVALID.dup
        response[MESSAGE] = 'Token Invalid'
        render :json => response, :status => response[STATUS_CODE]
      else
        response = NOT_ACCEPTABLE.dup
        response[MESSAGE] = 'Parameter missing'
        render :json => response, :status => response[STATUS_CODE]
      end
    rescue Exception => e
      puts "password exception = #{e}"
      #Log Exception
      exception_job = {:controller_action => "reset_password_exception", :exception => e.message, :backtrace => e.backtrace.inspect, :version=>"v1"}
      Resque.enqueue(ExceptionLogJob, exception_job)
      render :json => EXCEPTION, :status => RESP_ERROR_CODE
    end
  end

  def verify
    begin
      unless params.has_key?(:token)
        response = BAD_REQUEST.dup
        response[MESSAGE] = 'Verification Token not present'
        render :json => response, :status => response[STATUS_CODE]
      else
        unless Member.where(token: params[:token]).exists?
          response = FORBIDDEN.dup
          response[MESSAGE] = 'Verification Token not Valid'
          render :json => response, :status => response[STATUS_CODE]
        else
          member = Member.where(token: params[:token])[0]
          member.update(verified: true)
          activity = {:updated_by => member.email, :role => member.role, :member_id => member.member_id, :activity => "Profile verified", :version=>"v1"}
          Resque.enqueue(ActivityLoggerJob, activity)
          redirect_to "http://104.198.98.165:8082/login"
        end
      end
    rescue Exception => e
      puts "User Verification Exception = #{e}"
      exception_job = {:controller_action => "authentication_verify", :exception => e.message, :backtrace => e.backtrace.inspect, :version=>"v1"}
      Resque.enqueue(ExceptionLogJob, exception_job)
      response = EXCEPTION.dup
      render :json => response, :status => response[EXCEPTION]
    end
  end


end
