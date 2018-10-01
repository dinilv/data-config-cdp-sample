class Config::CampaignService < ApplicationService
  def create_campaign(campaign_data, auth_token, ip)
    campaign = Campaign.new
    currency_exchange = 1
    if auth_token[ROLE]==3
      campaign[CONTENT_PROVIDER_ID] = auth_token[CONTENT_PROVIDER_ID].to_i
      campaign[COMPANY_ID]=campaign[CONTENT_PROVIDER_ID]
    elsif auth_token[ROLE]==4
      campaign[CONTENT_PROVIDER_ID] = auth_token[COMPANY_ID].to_i
      campaign[COMPANY_ID]=auth_token[COMPANY_ID].to_i
    end
    for key in campaign_data.keys
      case key
        when CAMPAIGN_NAME, ACQUISITION_MODEL, MT_DAILY_APPROVED,
            CAMPAIGN_TYPE,
            GATEWAY_SHARE, OPERATOR_SHARE
          campaign[key] = campaign_data[key]
        when LANDING_PAGE, SERVICE_CODE,KEYWORD
          if campaign_data[key]==nil
            campaign[key] = ""
          else
            campaign[key] = campaign_data[key]
          end


        when UNIT_CHARGE
          if auth_token[CURRENCY_ID] == 1
            campaign[UNIT_CHARGE_DOLLAR] = campaign_data[UNIT_CHARGE]
            campaign[UNIT_CHARGE_LOCAL] = campaign_data[UNIT_CHARGE]
            campaign[NET_CHARGE_DOLLAR] = campaign_data[NET_CHARGE]
            campaign[NET_CHARGE_LOCAL] = campaign_data[NET_CHARGE]
          else
            currency_exchange = get_currency(auth_token[CURRENCY_ID])
            campaign[UNIT_CHARGE_DOLLAR] = (campaign_data[UNIT_CHARGE] / currency_exchange.to_f).round(2)
            campaign[UNIT_CHARGE_LOCAL] = campaign_data[UNIT_CHARGE]
            campaign[NET_CHARGE_DOLLAR] = (campaign_data[NET_CHARGE] / currency_exchange.to_f).round(2)
            campaign[NET_CHARGE_LOCAL] = campaign_data[NET_CHARGE]

          end
        when CAMPAIGN_COUNTRY
          campaign[CAMPAIGN_COUNTRY_ID] = campaign_data[CAMPAIGN_COUNTRY]

        when OPERATORS
          operator_details = campaign_data[key]
          operator_details.each do |operator_data|
            operator= campaign.campaign_operator.new
            operator.operator_id = operator_data
            operator.save
          end
      end
    end
    campaign_history = Event.new
    campaign_history.ip = ip
    campaign_history.name = CAMPAIGN_CREATED
    campaign.created_by = auth_token[EMAIL]
    campaign_history.detail = CAMPAIGN_CREATED_BY + " " + auth_token[EMAIL]
    campaign_history.save
    unless campaign.save
      return false, "error in params"
    else
      set_campaign_ids(campaign[COMPANY_ID])
      activity = {:updated_by => auth_token[EMAIL], :company_id => auth_token[COMPANY_ID], :activity => CAMPAIGN_CREATED, :ip => ip, :module_id => 5}
      Resque.enqueue(AccessLogJob, activity)
      return true, campaign.campaign_id
    end


  end

  def update_campaign(campaign_data, auth_token, ip)

    campaign = Campaign.find_by(campaign_id: campaign_data[ID].to_i)
    unless campaign.content_provider_id == auth_token[CONTENT_PROVIDER_ID].to_i
      return false, "Campaign not belonging to the content provider"
    else
      update_string = 'updated'
      currency_exchange = 1
      CAMPAIGN_KEY.each do |key, value|
        campaign_value = {}
        campaign_value[value] = campaign_data[value]
        campaign.update_attributes(campaign_value)
      end

      for key in campaign_data.keys
        case key
          when OPERATORS
            i=0
            operator_details = campaign_data[key]
            operator = campaign.campaign_operator
            operator_details.each do |operator_data|
              operator[i][OPERATOR_ID] = operator_data[OPERATOR_ID]
              operator[i][STATUS]=operator_data[STATUS]
              operator[i].update
              i=i+1
              end
          when UNIT_CHARGE
            if auth_token[CURRENCY_ID] == 1
              campaign.update(unit_charge_dollar: campaign_data[UNIT_CHARGE])
              campaign.update(unit_charge_local: campaign_data[UNIT_CHARGE])
              campaign.update(net_charge_dollar: campaign_data[NET_CHARGE])
              campaign.update(net_charge_local: campaign_data[NET_CHARGE])

            else
              currency_exchange = get_currency(auth_token[CURRENCY_ID])
              campaign.update(unit_charge_dollar: (campaign_data[UNIT_CHARGE] / currency_exchange.to_f).round(2))
              campaign.update(unit_charge_local: campaign_data[UNIT_CHARGE])
              campaign.update(net_charge_dollar: (campaign_data[NET_CHARGE] / currency_exchange.to_f).round(2))
              campaign.update(net_charge_local: campaign_data[NET_CHARGE])
            end
          when MEDIA_DETAILS
            media_details = campaign_data[key]
            media_details.each do |media_detail|
              # check whether the media was already added
              unless campaign.campaign_media.where(media_id: media_detail[MEDIA_ID], campaign_id: campaign.campaign_id).exists?
                campaign_media = campaign.campaign_media.find_by(media_id: media_detail[MEDIA_ID])
                campaign_media.media_cap = media_detail[MEDIA_CAP]
                if auth_token[CURRENCY_ID] == 1
                  campaign_media.media_payout_dollar = media_detail[MEDIA_PAYOUT]
                  campaign_media.media_payout_local = media_detail[MEDIA_PAYOUT]
                else
                  campaign_media.media_payout_dollar = (media_detail[MEDIA_PAYOUT] / currency_exchange.to_f).round(2)
                  campaign_media.media_payout_local = media_detail[MEDIA_PAYOUT]
                end
                campaign_media.media_link = media_detail[MEDIA_LINK]
                campaign_media.status = media_detail[MEDIA_STATUS]
                campaign.update(updated_by: auth_token[MEMBER_ID])
                campaign.update(status:1)
                campaign_media.update

                #media = Media.where(media_id: media_detail[MEDIA_ID])[0]

              else
                campaign_media = campaign.campaign_media.where(media_id: media_detail[MEDIA_ID])[0]
                if media_detail[MEDIA_CAP] != nil && media_detail[MEDIA_PAYOUT] != nil
                  campaign_media.update(media_cap: media_detail[MEDIA_CAP], media_payout: media_detail[MEDIA_CAP])
                elsif media_detail[MEDIA_PAYOUT] != nil && media_detail[MEDIA_CAP] == nil
                  campaign_media.update(media_payout: media_detail[MEDIA_PAYOUT])
                elsif media_detail[MEDIA_PAYOUT] == nil && media_detail[MEDIA_CAP] != nil
                  campaign_media.update(media_cap: media_detail[MEDIA_CAP])
                end


              end
            end
        end
      end
      set_campaign_ids(auth_token[CONTENT_PROVIDER_ID].to_i)
      set_campaign_details(campaign_data[ID].to_i)
      activity = {:updated_by => auth_token[EMAIL], :content_provider_id => auth_token[CONTENT_PROVIDER_ID], :ip => ip}
      Resque.enqueue(AccessLogJob, activity)
      return true, "udpate success"
    end
  end

  def show_campaign(campaign_data, auth_token)

    campaign_details = Campaign.where(campaign_id: campaign_data[:id])
    response_obj = campaign_details
    return true, response_obj
  end


  def list_campaigns(params, auth_token)
    if params[OFFSET]
      offset = params[OFFSET]
    end
    if params[LIMIT]
      limit = params[LIMIT]
    end

    offset = limit.to_i * (offset.to_i - 1)
    campaigns = Campaign.where(content_provider_id: auth_token[CONTENT_PROVIDER_ID])
    count = campaigns.count
    campaigns = campaigns.all.skip(offset).limit(limit)
    response_array = []
    campaigns.each do |campaign|
      campaign_hash = campaign.attributes
      campaign_hash['total_landing_page'] = rand(1000000..5000000)
      campaign_hash['engagement'] = rand(1000000..campaign_hash['total_landing_page'])
      campaign_hash['total_subscribers'] = rand(15000..100000)
      campaign_hash['total_active_subscribers'] = rand(15000..campaign_hash['total_subscribers'])
      campaign_hash['mt_sent'] = rand(1000000..3500000)
      campaign_hash['mt_success'] = rand(1000000..campaign_hash['mt_sent'])
      campaign_hash['revenue'] = rand(100000..1000000)
      campaign_hash['media_cost'] = rand(100000..campaign_hash['revenue'])
      response_array << campaign_hash
    end
    return_obj = {}
    return_obj['campaigns'] = response_array
    return_obj['total_count'] = count
    return true, return_obj

  end

  def create_campaign_media(campaign_data, auth_token, ip)
    campaign = Campaign.find_by(campaign_id: campaign_data[CAMPAIGN_ID])
    currency_exchange = get_currency(auth_token[CURRENCY_ID])
    for key in campaign_data.keys
      case key
        when MEDIA_DETAILS
          media_details = campaign_data[key]
          media_details.each do |media_detail|
            campaign_media = campaign.campaign_media.new
            campaign_media.media_id = media_detail[MEDIA_ID]
            campaign_media.media_cap = media_detail[MEDIA_CAP]
            if auth_token[CURRENCY_ID] == 1
              campaign_media.media_payout_dollar = media_detail[MEDIA_PAYOUT]
              campaign_media.media_payout_local = media_detail[MEDIA_PAYOUT]
            else
              campaign_media.media_payout_dollar = (media_detail[MEDIA_PAYOUT] / currency_exchange.to_f).round(2)
              campaign_media.media_payout_local = media_detail[MEDIA_PAYOUT]
            end
            campaign_media.media_link = media_detail[MEDIA_LINK]
            campaign_media.save
            campaign.update(status: 1)
          end
      end
    end
    set_campaign_details(campaign.campaign_id)
    set_campaign_media(campaign.campaign_id, campaign.campaign_media[0].media_id)
    return true, "success"
  end

  #redis data



end
