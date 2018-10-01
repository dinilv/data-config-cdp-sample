class V1::Campaigns::CampaignController < ApplicationController
    before_action :authorize, :only => [:create, :index, :show, :update, :get_id]
    before_action :token_renew, :only => [:create, :index, :show, :update, :get_id]
    def create
        begin
            if !params.has_key?(:media_details)
                status, message = @@campaign_service.create_campaign(params,@auth_token,request.remote_ip)
            else
                status, message = @@campaign_service.create_campaign_media(params,@auth_token,request.remote_ip)
            end
            unless status
                response = GlobalResponseConstants::REQUEST_INVALID.dup
                response[GlobalResponseConstants::MESSAGE] = message
                render :json => response, :status => response[GlobalResponseConstants::STATUS_CODE]
            else
                response = GlobalResponseConstants::SUCCESS.dup
                response[GlobalResponseConstants::DATA] = message
                render :json => response, :status => response[GlobalResponseConstants::STATUS_CODE]
            end
        rescue Exception => e
            puts "Campaign List = #{e}"
            exception_job = {:controller_action => "campaign_create", :exception => e.message , :backtrace => e.backtrace.inspect, :version=>"v1"}
            Resque.enqueue(ExceptionLogJob,exception_job)
            response = GlobalResponseConstants::EXCEPTION.dup
            render :json => response, :status => response[GlobalResponseConstants::EXCEPTION]
        end
    end

    def index
        begin
            status, data = @@campaign_service.list_campaigns(params,@auth_token)
            unless status
                response = GlobalResponseConstants::EXCEPTION.dup
                render :json => response, :status => response[GlobalResponseConstants::STATUS_CODE]
            else
                response = GlobalResponseConstants::SUCCESS.dup
                response[GlobalResponseConstants::DATA] = data
                render :json => response, :status => response[GlobalResponseConstants::STATUS_CODE]
            end
        rescue Exception => e
            puts "Campaign List = #{e}"
            exception_job = {:controller_action => "campaign_list", :exception => e.message , :backtrace => e.backtrace.inspect, :version=>"v1"}
            Resque.enqueue(ExceptionLogJob,exception_job)
            response = GlobalResponseConstants::EXCEPTION.dup
            render :json => response, :status => response[GlobalResponseConstants::EXCEPTION]
        end
    end

    def show
        begin
            status, data = @@campaign_service.show_campaign(params,@auth_token)
            if status
                response = GlobalResponseConstants::SUCCESS.dup
                response[GlobalResponseConstants::DATA] = data
                render :json => response, :status => response[GlobalResponseConstants::STATUS_CODE]
            elsif !status && data == "exception"
                response = GlobalResponseConstants::EXCEPTION.dup
                render :json => response, :status => response[GlobalResponseConstants::STATUS_CODE]
            else
                response = GlobalResponseConstants::REQUEST_INVALID.dup
                response[GlobalResponseConstants::MESSAGE] = data
                render :json => response, :status => response[GlobalResponseConstants::STATUS_CODE]
            end
        rescue Exception => e
            puts "Campaign show = #{e}"
            exception_job = {:controller_action => "campaign_show", :exception => e.message , :backtrace => e.backtrace.inspect, :version=>"v1"}
            Resque.enqueue(ExceptionLogJob,exception_job)
            response = GlobalResponseConstants::EXCEPTION.dup
            render :json => response, :status => response[GlobalResponseConstants::EXCEPTION]
        end
    end

    def update
        begin
            status, message = @@campaign_service.update_campaign(params,@auth_token,request.remote_ip)
            unless status
                unless message == "invalid campaign id"
                  response = GlobalResponseConstants::EXCEPTION.dup
                else
                  response = GlobalResponseConstants::REQUEST_INVALID.dup
                  response[GlobalResponseConstants::MESSAGE] = message
                end
                render :json => response, :status => response[GlobalResponseConstants::STATUS_CODE]
            else
                response = GlobalResponseConstants::SUCCESS.dup
                render :json => response, :status => response[GlobalResponseConstants::STATUS_CODE]
            end
        rescue Exception => e
            puts "Campaign show = #{e}"
            exception_job = {:controller_action => "campaign_update_controller", :exception => e.message , :backtrace => e.backtrace.inspect,:version=>"v1"}
            Resque.enqueue(ExceptionLogJob,exception_job)
            response = GlobalResponseConstants::EXCEPTION.dup
            render :json => response, :status => response[GlobalResponseConstants::EXCEPTION]
        end
    end

    def get_id
      begin
          status, data = @@campaign_service.fetch_campaign_id
          unless status
              response = GlobalResponseConstants::EXCEPTION.dup
              render :json => response, :status => response[GlobalResponseConstants::STATUS_CODE]
          else
              response = GlobalResponseConstants::SUCCESS.dup
              response[GlobalResponseConstants::DATA] = data
              render :json => response, :status => response[GlobalResponseConstants::STATUS_CODE]
          end
      rescue Exception => e
          puts "Campaign get id = #{e}"
          exception_job = {:controller_action => "campaign_get_id_controller", :exception => e.message , :backtrace => e.backtrace.inspect, :version=>"v1"}
          Resque.enqueue(ExceptionLogJob,exception_job)
          response = GlobalResponseConstants::EXCEPTION.dup
          render :json => response, :status => response[GlobalResponseConstants::EXCEPTION]
      end
    end



end
