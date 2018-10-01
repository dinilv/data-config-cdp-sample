class Config::MigrationService < ApplicationService

  def create_campaign_migration(params)
    campaign = Campaign.new
    content_provider = ContentProvider.where(content_provider_id: params[:user_id])[0]
    campaign = Campaign.new
    campaign[CONTENT_PROVIDER_ID] = content_provider.content_provider_id
    campaign[COMPANY_ID] = content_provider.content_provider_id
    campaign[CAMPAIGN_NAME] = params[CAMPAIGN_NAME]
    campaign[ACQUISITION_MODEL] = params[ACQUISITION_MODEL].to_i
    if campaign[ACQUISITION_MODEL]==0
      if params[CAMPAIGN_LANDING_URL]!=nil
        campaign[LANDING_PAGE]=params[CAMPAIGN_LANDING_URL]
      else
        campaign[LANDING_PAGE]="" 
      end
    else if campaign[ACQUISITION_MODEL]==1
           if params[SERVICE_CODE]!=nil 
             campaign[SERVICE_CODE]=params[SERVICE_CODE]
           else
             campaign[SERVICE_CODE] ="" 
           end
           end
      end
    campaign[MT_DAILY_APPROVED] = params[MT_DAILY_APPROVED].to_i
    campaign[UNIT_CHARGE_DOLLAR] = params[UNIT_CHARGE].to_f
    campaign[UNIT_CHARGE_LOCAL]=params[UNIT_CHARGE].to_f
    campaign[KEYWORD]=params[KEYWORD]
    campaign[COUNTRY_ID]=params[CAMPAIGN_COUNTRY_ID]
    campaign[GATEWAY_SHARE]=params[GATEWAY_SHARE].to_f
    campaign[OPERATOR_SHARE]=params[OPERATOR_SHARE].to_f
    campaign[NET_CHARGE_DOLLAR]=campaign.unit_charge_dollar*((campaign.operator_share+campaign.gateway_share)/100)
    campaign[NET_CHARGE_LOCAL]=campaign.net_charge_dollar
    campaign[CURRENCY_ID]=1
    campaign[CATEGORY]=1

    operators=params[OPERATORS]
    operator=[]
    operators.each do |key,value|
      key=key.to_i
     operator.push(key)
    end
    operator_data = campaign.campaign_operator.new
    operator_data.operator_id =operator
    operator_data.save
    media_details = params[MEDIA_DETAILS]
    media_details.each do |media_detail|
        campaign_media = campaign.campaign_media.new
        campaign_media.media_id = media_detail[MEDIA_ID]
        # campaign_media.media_name = media_detail[MEDIA_NAME]
        campaign_media.media_cap = media_detail[MEDIA_CAP]
        campaign_media.media_payout_dollar = media_detail[MEDIA_PAYOUT]
        campaign_media.media_payout_local = media_detail[MEDIA_PAYOUT]
        campaign_media.media_link = media_detail[MEDIA_LINK]
        campaign_media.save
    end
    campaign_history = Event.new
    campaign.status=1
    campaign_history.name = CAMPAIGN_CREATED
    campaign.created_by=params[:user_id]
    campaign_history.detail =CAMPAIGN_MIGRATED_BY+" "+params[:userEmail]
    campaign_history.save
    
    unless campaign.save
      return false, "error in params"
    else
      campaign.update(campaign_id:params[:campaign_id])
      Aggregator::CampaignDailyJob.perform(params[:campaign_id], Time.now.to_date)
      set_campaign_ids(params[:user_id])
      set_campaign_details(campaign.campaign_id)
      set_campaign_media(campaign.campaign_id,campaign.campaign_media[0].media_id)
      return true, "success"
    end
  end
  def create_content_provider(content_provider_data)
      if (!ContentProvider.where(email: content_provider_data[:email]).exists?)
        content_provider = ContentProvider.new
        content_provider.email = content_provider_data[:email].downcase
        content_provider.first_name = content_provider_data[:first_name]
        content_provider.timezone_id=0
        content_provider.language_id=0
        content_provider.currency_id=1
        content_provider.keys = SecureRandom.hex(13)
        content_provider.company_id=content_provider_data[:id]
        content_provider.api_limit = 5000
        content_provider.click_limit = 3000000
        unless content_provider.save
          return false, "Required fields are missing."
        else

          content_provider.update(content_provider_id:content_provider_data[:id])
          set_cp_details(content_provider_data[:id])
          return true, "Success"
        end
      elsif ContentProvider.where(email: content_provider_data[:email]).exists?
        return false, "Email already used, please use different email address."
      elsif RegexValidation.email_validate(content_provider_data[:email]) != 0
        return false, "Invalid email address."
      end
  end

  def create_media(media_data)
    media = Media.new
    media.media_template = media_data[:media_template]
    media.media_name =  media_data[:media_name]
    media.media_id=media_data[:media_id]
    media.countryIDs=media_data[:countryIDs].to_a
    media.save
    set_media_data(media_data[:media_id])
    return true,"success"

  end
end