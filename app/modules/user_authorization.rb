module UserAuthorization
  def authorize
      begin
          unless request.headers['Authorization'].present?
              response = GlobalResponseConstants::AUTH_ERROR.dup
              response[GlobalResponseConstants::MESSAGE] = 'Please login to continue'
              render :json => response, :status => response[GlobalResponseConstants::STATUS_CODE]
          else
              http_token = request.headers['Authorization'].split(' ').last
              @auth_token = JsonWebToken.decode(http_token)
              unless (@auth_token['role'] == 3 || @auth_token['role'] == 1 )
                  response = GlobalResponseConstants::FORBIDDEN.dup
                  response[GlobalResponseConstants::MESSAGE] = 'Not authorized, to view this page'
                  render :json => response, :status => response[GlobalResponseConstants::STATUS_CODE]
              end
          end
      rescue Exception => e
          puts "Member authorization Exception = #{e}"
          exception_job = {:controller_action => "authentication_authorize", :exception => e.message, :backtrace => e.backtrace.inspect}
          Resque.enqueue(ExceptionLogJob,exception_job)
          response = GlobalResponseConstants::AUTH_ERROR.dup
          render :json => response, :status => response[GlobalResponseConstants::EXCEPTION]
      end
  end
  
end
