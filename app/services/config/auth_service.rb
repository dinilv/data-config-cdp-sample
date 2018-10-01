class Config::AuthService < ApplicationService
  require 'json'
  require 'open-uri'
  require 'net/http'
  def log_in(params,ip)
    unless Member.where(email: params[:email].downcase).exists? && Member.where(email: params[:email].downcase, verified: true).exists?
        payload = {}
        user_data={}
        status = false
        #checking adcamie user in CP db
        if ContentProvider.where(email: params[:email].downcase).exists?
          #authentication with adcamie
          cp_id=ContentProvider.find_by(email: params[:email])
          status, data = auth_adcamie(params[:email], params[:password])
          if status != "User does not exist/not verified"
            adcamie_user = data['data']
            user_data[ROLE] = 3
            user_data[EMAIL] = adcamie_user[EMAIL]
            payload[CONTENT_PROVIDER_ID] = cp_id[CONTENT_PROVIDER_ID]
            user_data[CONTENT_PROVIDER_ID]=cp_id[CONTENT_PROVIDER_ID]
            user_data[COMPANY_ID]=cp_id[CONTENT_PROVIDER_ID]
            user_data[TIMEZONE_ID]=cp_id[TIMEZONE_ID]
            user_data[CURRENCY_ID]=cp_id[CURRENCY_ID]
            user_data[LANGUAGE_ID]=cp_id[LANGUAGE_ID]
            user_data[TOKEN] = JsonWebToken.encode(payload)
            set_user_data(user_data, user_data[TOKEN])
            set_login_expire(user_data[TOKEN])
            set_active_token(user_data[TOKEN])
            return true,user_data
          else
            response = AUTH_ERROR.dup
            activity = {:user_name => params[:email], :ip => ip, :status => "Password Wrong"}
            Resque.enqueue(AccessLogJob, activity)
            return false,response
          end
        else
          #checking adcamie user mananger or admin
          status, data = auth_adcamie(params[:email], params[:password])
          if status != "User does not exist/not verified"
            adcamie_user = data['data']
            payload[ROLE] = adcamie_user[ROLE]
            if adcamie_user[ROLE]==3 || adcamie_user[ROLE]==4
              response = AUTH_ERROR.dup
              response[MESSAGE]="User does not migrated"
              return false,response
            elsif adcamie_user[ROLE]== 2 || adcamie_user[ROLE]==1
              user_data[ROLE] = adcamie_user[ROLE]
              user_data[EMAIL] = adcamie_user[EMAIL]
              payload[COMPANY_ID] = ADMIN_ACCOUNT
              user_data[COMPANY_ID] = ADMIN_ACCOUNT
              user_data[TIMEZONE_ID]=1
              user_data[CURRENCY_ID]=1
              user_data[LANGUAGE_ID]=1
              user_data[TOKEN] = JsonWebToken.encode(payload)
              set_user_data(user_data, user_data[TOKEN])
              set_login_expire(user_data[TOKEN])
              set_active_token(user_data[TOKEN])
              return true,user_data
            end
          else
            response = AUTH_ERROR.dup
            activity = {:user_name => params[:email], :ip => ip, :status => "Password Wrong"}
            Resque.enqueue(AccessLogJob, activity)
            return false,response
          end
        end
        # respond not found
      else
        # get member details
        member = Member.where(email: params[:email].downcase)[0]
        password = Digest::SHA2.hexdigest(member.password_salt + params[:password])
        unless password == member.password
          response = AUTH_ERROR.dup
          activity = {:user_name => params[:email], :ip => ip, :status => "Password Wrong"}
          Resque.enqueue(AccessLogJob, activity)
          return false,response
        else
          payload = {}
          response_obj = {}
          response_redis = {}
          response_obj[ROLE] = member.role
          response_obj[IS_FIRST] = member.is_first_login
          response_obj[EMAIL]=member.email
          if member.is_first_login == true
            member.update(is_first_login: false)
          end
          if member.role == 3
            content_provider = ContentProvider.where(email: params[:email])[0]
            payload[CONTENT_PROVIDER_ID] = content_provider.content_provider_id
            response_obj[CONTENT_PROVIDER_ID] = payload[CONTENT_PROVIDER_ID].to_s
            response_obj[COMPANY_ID]=payload[CONTENT_PROVIDER_ID].to_s
            response_obj[FIRST_NAME] = content_provider.first_name
            response_obj[TIMEZONE_ID] = content_provider.timezone_id
            response_obj[LANGUAGE_ID] = content_provider.language_id
            response_obj[CURRENCY_ID] = content_provider.currency_id

          elsif member.role == 2
            response_obj[CONTENT_PROVIDER_ID] = ADMIN_ACCOUNT
            response_obj[COMPANY_ID]=ADMIN_ACCOUNT
            response_obj[TIMEZONE_ID]=1
            response_obj[CURRENCY_ID]=1
            response_obj[LANGUAGE_ID]=1
            payload[CONTENT_PROVIDER_ID]=ADMIN_ACCOUNT

          elsif member.role == 4
            company = Company.where(email: params[:email])[0]
            payload[COMPANY_ID] = company.company_id
            response_obj[COMPANY_ID]=payload[COMPANY_ID.to_s]
            response_obj[CONTENT_PROVIDER_ID] =payload[COMPANY_ID].to_s
            response_obj[COUNTRY_ID] = company.country_id
            response_obj[TIMEZONE_ID] = company.timezone_id
            response_obj[LANGUAGE_ID] = company.language_id
          end
          response_obj[TOKEN] = JsonWebToken.encode(payload)
          set_user_data(response_obj,response_obj[TOKEN])
          set_login_expire(response_obj[TOKEN])
          set_active_token(response_obj[TOKEN])
          return true,response_obj

        end
      end
  end
  def auth_adcamie(email, password)
    localhost="http://localhost:3000/signin"
    url="https://advertiser.adcamie.com/signin"
    header = {'Content-Type' => 'application/json'}
    signin = URI.parse(url)
    user_data = {"username" => email, "password" => password}
    begin
      http = Net::HTTP.new(signin.host, signin.port)
      http.use_ssl = true
      request = Net::HTTP::Post.new(signin.request_uri, header)
      request.body = user_data.to_json
      response = http.request(request)
      if response.code == "200"
        return true, JSON.parse(response.body)
      else
        response[MESSAGE] = "User does not exist/not verified"
      end
    rescue Exception => e
      puts "Cmp add event Exception = #{e.message}"
    end
  end
end