class V1::Admin::AdminController <  ApplicationController
  before_action :admin_authorize, :only => [:create_media,:update_media,:show_media]
  before_action :authorize, :only=>[:list_media]
    def create_media
        begin
            unless  params.has_key?(:media_template) && params.has_key?(:media_name)
                response = NOT_ACCEPTABLE.dup
                render :json => response, :status => response[STATUS_CODE]
            else
                status,message = @@admin_service.create_media(params)
                unless status
                    response = EXCEPTION.dup
                    render :json => response, :status => response[STATUS_CODE]
                else
                    response = SUCCESS.dup
                    render :json => response, :status => response[STATUS_CODE]
                end
            end
        rescue Exception => e
            puts e
            exception_job = {:controller_action => "admin_create_media_controller", :exception => e.message, :backtrace => e.backtrace.inspect, :vesion=>"v1"}
            Resque.enqueue(ExceptionLogJob,exception_job)
            response = EXCEPTION.dup
            render :json => response, :status => response[STATUS_CODE]
        end
    end
    def update_media
      begin
        unless  params.has_key?(:media_id)&& params.has_key?(:media_name)&& params.has_key?(:media_template)
          response = NOT_ACCEPTABLE.dup
          render :json => response, :status => response[STATUS_CODE]
        else
          status,message = @@admin_service.update_media(params)
          unless status
            response = EXCEPTION.dup
            render :json => response, :status => response[STATUS_CODE]
          else
            response = SUCCESS.dup
            render :json => response, :status => response[STATUS_CODE]
          end
        end
      rescue Exception => e
        exception_job = {:controller_action => "admin_update_media_controller", :exception => e.message, :backtrace => e.backtrace.inspect, :version=> "v1"}
        Resque.enqueue(ExceptionLogJob,exception_job)
        response = EXCEPTION.dup
        render :json => response, :status => response[STATUS_CODE]
      end
    end
    def list_media
      if params[OFFSET]
        offset=params[OFFSET]
      end
      if params[LIMIT]
        limit=params['limit']
      end
        begin
          offset=limit.to_i*(offset.to_i-1)
          media = Media.all.skip(offset).limit(limit)
          count=media.count
          response = SUCCESS.dup
          response[DATA] = media
          response[TOTAL_COUNT] = count
          render :json => response, :status => response[STATUS_CODE]
      rescue Exception => e
          exception_job = {:controller_action => "admin_listing_media_controller", :exception => e.message, :backtrace => e.backtrace.inspect, :version=>"v1"}
          Resque.enqueue(ExceptionLogJob,exception_job)
          response = EXCEPTION.dup
          render :json => response, :status => response[STATUS_CODE]
      end
    end
    def show_media
      begin
        status, data = @@admin_service.show_media(params)
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
        exception_job = {:controller_action => "media_show", :exception => e.message , :backtrace => e.backtrace.inspect, :version=>"v1"}
        Resque.enqueue(ExceptionLogJob,exception_job)
        response = EXCEPTION.dup
        render :json => response, :status => response[EXCEPTION]
      end
    end
    def validate_email
        begin
            unless params.has_key?(:email) && params.has_key?(:token)
              response = NOT_ACCEPTABLE.dup
              render :json => response, :status => response[STATUS_CODE]
            else
              unless ContentProvider.where(email: params[:email],keys: params[:token]).exists?
                response = ZERO_CONTENT.dup
                render :json => response, :status => response[STATUS_CODE]
              else
                content_provider = ContentProvider.where(email: params[:email], keys: params[:token])[0]
                response_obj = {}
                response_obj['email'] = content_provider.email
                response_obj['id'] = content_provider.content_provider_id
                response = SUCCESS.dup
                response[DATA] = response_obj
                render :json => response, :status => response[STATUS_CODE]
              end
            end
        rescue Exception => e
            exception_job = {:controller_action => "admin_validate_email_controller", :exception => e.message, :backtrace => e.backtrace.inspect, :version=>"v1"}
            Resque.enqueue(ExceptionLogJob,exception_job)
            response = EXCEPTION.dup
            render :json => response, :status => response[STATUS_CODE]
        end
    end
end
