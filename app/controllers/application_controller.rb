class ApplicationController < ActionController::API

  require 'json'
  require 'csv'

  #constants
  include AggregationConstants
  include GlobalResponseConstants
  include ConfigConstants
  include DbConstants
  include ReportImportConstants
  include ReportConstants
  include ApiConstants
  include DropdownsConstants
  include RedisHelper


  #token
  @auth_token={}

  #service access
  @@campaign_service = Config::CampaignService.new
  @@admin_service = Config::AdminService.new
  @@operator_service=Config::OperatorService.new
  @@redis_service=Redis::RedisDaoService.new
  @@migration_service=Config::MigrationService.new
  @@operator_sync = Config::OperatorSyncService.new
  @@company_service=Config::CompanyService.new
  @@request_service=Config::RequestService.new
  @@content_provider_service = Config::ContentProviderService.new
  @@auth_service = Config::AuthService.new

  #logger
  @@logger_controller = Logger.new 'log/cmp_controller.log'

  #token validations
  def authorize
      begin
          unless request.headers[AUTHORIZATION].present?
              response = AUTH_ERROR.dup
              response[MESSAGE] = AUTHORIZATION_STATUS
              render :json => response, :status => response[STATUS_CODE]
          else
              http_token = request.headers[AUTHORIZATION].split(' ').last
              if @@redis_service.token_exist(AUTH_TOKEN+http_token)
                set_active_token(http_token)
                @auth_token = get_user_data(http_token)
                unless (@auth_token[ROLE] == 3 || @auth_token[ROLE] == 1 || @auth_token[ROLE] == 2 ||@auth_token[ROLE] == 4)
                  response = FORBIDDEN.dup
                  response[MESSAGE] = UNAUTHORIZATION
                  #add to access log
                  render :json => response, :status => response[STATUS_CODE]
                end
              else
                response = BAD_REQUEST.dup
                response[MESSAGE] = TOKEN_EXPIRED
                #add to access log
                render :json => response, :status => response[STATUS_CODE]
              end
          end
      rescue Exception => e
          exception_job = {:controller_action => "authentication_authorize", :exception => e.message, :backtrace => e.backtrace.inspect}
          Resque.enqueue(ExceptionLogJob,exception_job)
          response = AUTH_ERROR.dup
          render :json => response, :status => response[EXCEPTION]
      end
  end


  def admin_authorize
    begin
      unless request.headers[AUTHORIZATION].present?
        response = AUTH_ERROR.dup
        response[MESSAGE] = AUTHORIZATION_STATUS
        render :json => response, :status => response[STATUS_CODE]
      else
        http_token = request.headers[AUTHORIZATION].split(' ').last
        if @@redis_service.token_exist(AUTH_TOKEN+http_token)
          set_active_token(http_token)
          @auth_token = get_user_data(http_token)
          unless (@auth_token[ROLE] == 1 || @auth_token[ROLE] == 2)
            response = FORBIDDEN.dup
            response[MESSAGE] = UNAUTHORIZATION_ADMIN
            #add to access log
            render :json => response, :status => response[STATUS_CODE]
          end
        else
          response = BAD_REQUEST.dup
          response[MESSAGE] = TOKEN_EXPIRED
          #add to access log
          render :json => response, :status => response[STATUS_CODE]
        end
      end
    rescue Exception => e
      exception_job = {:controller_action => "authentication_authorize", :exception => e.message, :backtrace => e.backtrace.inspect ,:version=>"v1"}
      Resque.enqueue(ExceptionLogJob,exception_job)
      response = AUTH_ERROR.dup
      render :json => response, :status => response[EXCEPTION]
    end
  end

  #for active tokens
  def token_renew
    set_active_token(@auth_token[TOKEN])
  end



end
