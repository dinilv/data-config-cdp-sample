class Config::ContentProviderService < ApplicationService

    def create_content_provider(content_provider_data,ip)
          if (!ContentProvider.where(email: content_provider_data[:email]).exists? && RegexValidation.email_validate(content_provider_data[:email]) == 0 && RegexValidation.name_validate(content_provider_data[:first_name]) == true && RegexValidation.name_validate(content_provider_data[:last_name]) == true && content_provider_data[:password] != content_provider_data[:email] && content_provider_data[:password] != content_provider_data[:first_name] && content_provider_data[:password] != content_provider_data[:last_name] && content_provider_data[:password].length >= 5)
              content_provider = ContentProvider.new
              content_provider.email = content_provider_data[:email].downcase
              content_provider.first_name = content_provider_data[:first_name]
              content_provider.last_name = content_provider_data[:last_name]
              content_provider.contact = content_provider_data[:contact]
              content_provider.timezone_id=content_provider_data[:timezone]
              content_provider.language_id=content_provider_data[:language]
              content_provider.currency_id=content_provider_data[:currency_id]
              content_provider.country_id=content_provider_data[:country_id]
              content_provider.company_name=content_provider_data[:company_name]
              content_provider.company_billing_address=content_provider_data[:company_address]
              content_provider.keys = SecureRandom.hex(13)
              content_provider.api_limit = 5000
              content_provider.click_limit = 3000000
              member = Member.new
              member.email = content_provider_data[:email]
              member.role = 3
              member.token = SecureRandom.hex(8)
              member.password_salt = SecureRandom.base64(6)
              member.password = Digest::SHA2.hexdigest(member.password_salt + content_provider_data[:password])
              unless content_provider.save && member.save
                  return false, "Required fields are missing."
              else
                  self.set_cp_details(content_provider.content_provider_id)
                  link = ACCOUNT_VERIFICATION + member.token
                  mail_info = {"recipients" => member.email, "subject" => 'CMP Onboarding', "link" => link, "first_name" => content_provider.first_name}
                  Resque.enqueue(MailingJob,mail_info,1)
                  return true, "Success"
              end
          elsif ContentProvider.where(email: content_provider_data[:email]).exists?
              return false, "Email already used, please use different email address."
          elsif RegexValidation.email_validate(content_provider_data[:email]) != 0
              return false, "Invalid email address."
          elsif content_provider_data[:password] == content_provider_data[:email]
              return false, "Password and email cannot be same."
          elsif content_provider_data[:password] == content_provider_data[:first_name]
              return false, "Password and first name cannot be same."
          end
    end

    def update_content_provider(content_provider_data,auth_token,ip)

        content_provider = ContentProvider.where(content_provider_id: content_provider_data[:id].to_i)[0]
        update_string = 'Updated'
        ConfigConstants::CONTENT_PROVIDER_KEY.each do |key,value|
            content_value={}
            content_value[value]=content_provider_data[value]
            content_provider.update_attributes(content_value)
        end
        payload = {:card_details => content_provider_data[ConfigConstants::CARD_DETAILS]}
        content_provider.update(card_details: JsonWebToken.encode(payload))
        activity = {:updated_by => auth_token['email'], :content_provider_id => content_provider.content_provider_id, :activity => update_string, :version=>"v1", :ip => ip}
        Resque.enqueue(ActivityLoggerJob,activity)
        return true


    end
    def dashboard
        curr_date = Date.today
        start_date = curr_date - 30
        response_array = []
        (start_date..curr_date).each_with_index do |day,index|
            response = {}
            if index == 0
                response['yesterday_active'] = 120
            else
                response['yesterday_active'] = response_array[index-1]['today_active']
            end
            response['date'] = day.strftime("%d %b")
            response['today_active'] = ((rand(100.0..200.0)*100).to_i/100.0)
            response['today_arpu'] = ((rand(0.0..10.0)*100).to_i/100.0)
            response['total_subscribers'] = ((rand(70.00..190.00)*100).to_i/100.0)
            response['daily_subscription'] = ((rand(0.00..10.00)*100).to_i/100.0)
            response['new_sub_unsub'] = ((rand(0.0..35.00)*100).to_i/100.0)
            response['mt_success'] = ((rand(0.00..23.00)*100).to_i/100.0)
            response['actual_revenue'] = ((rand(65.00..140.00)*100).to_i/100.0)
            response['media_spent'] = ((rand(0.00..18.00)*100).to_i/100.0)
            response_array << response
        end
        return true, response_array
    end



    def show_content_provider(cid)
        cp_details = ContentProvider.find_by(content_provider_id: cid[:id].to_i)
        response_obj =  cp_details
        return true, response_obj
    end



end
