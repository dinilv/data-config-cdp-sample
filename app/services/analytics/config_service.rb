class Analytics::ConfigService < ApplicationService

  def add_media_details(report_hash)
    redis_data =get_media_data(report_hash[MEDIA_ID])
    report_hash[MEDIA_NAME] = redis_data
  end

  def add_operator_details(report_hash)
    redis_data = get_operator_data(report_hash[OPERATOR_ID])
    report_hash[OPERATOR_NAME] = redis_data
  end

  def add_campaign_media_details(report_hash)
    redis_data =get_campaign_media(report_hash[CAMPAIGN_ID], report_hash[MEDIA_ID])
    report_hash[MEDIA_NAME] = redis_data[MEDIA_NAME]
    report_hash[MEDIA_CAP] = redis_data[MEDIA_CAP]
    report_hash[MEDIA_PAYOUT_DOLLAR] = Dollar.new(redis_data[MEDIA_PAYOUT_DOLLAR])
    report_hash[MEDIA_PAYOUT_LOCAL] = Amount.new(report_hash[CURRENCY], redis_data[MEDIA_PAYOUT_LOCAL])
  end

  def add_campaign_details(report_hash)
    redis_data=get_campaign_details(report_hash[CAMPAIGN_ID])
    #campaign details
    report_hash[CAMPAIGN_NAME]=redis_data[CAMPAIGN_NAME]
    report_hash[COUNTRY]=COUNTRY_MAP[redis_data[COUNTRY_ID]]
    report_hash[ACQUISITION_MODEL]=redis_data[ACQUISITION_MODEL]
    report_hash[SERVICE_CODE]=""
    report_hash[LANDING_PAGE]=""
    #handling different acq-models
    if report_hash[ACQUISITION_MODEL]=="SMS"
      report_hash[SERVICE_CODE]=redis_data[SERVICE_CODE]
    end
    if report_hash[ACQUISITION_MODEL]=="WAP"
      report_hash[LANDING_PAGE]=redis_data[LANDING_PAGE]
    end
    report_hash[MT_DAILY_APPROVED]=redis_data[MT_DAILY_APPROVED]
    report_hash[UNIT_CHARGE_DOLLAR]=Dollar.new(redis_data[UNIT_CHARGE_DOLLAR])
    report_hash[UNIT_CHARGE_LOCAL]=Amount.new(redis_data[CURRENCY],redis_data[UNIT_CHARGE_LOCAL])
    report_hash[NET_CHARGE_DOLLAR]=Dollar.new(redis_data[NET_CHARGE_DOLLAR])
    report_hash[NET_CHARGE_LOCAL]=Amount.new(redis_data[CURRENCY],redis_data[NET_CHARGE_LOCAL])
    report_hash[KEYWORD]=redis_data[KEYWORD]
    report_hash[GATEWAY_SHARE]=Percentage.new(redis_data[GATEWAY_SHARE])
    report_hash[OPERATOR_SHARE]=Percentage.new(redis_data[OPERATOR_SHARE])
    report_hash[LIVE_OPERATORS]=redis_data[LIVE_OPERATORS]
    report_hash[LIVE_MEDIA]=redis_data[LIVE_MEDIA]
    report_hash[LIVE_OPERATOR_COUNT]=redis_data[LIVE_OPERATOR_COUNT]
    report_hash[LIVE_MEDIA_COUNT]=redis_data[LIVE_MEDIA_COUNT]
    report_hash[COMPANY_ID] = redis_data[COMPANY_ID]
    report_hash[CURRENCY_ID] = redis_data[CURRENCY_ID]
    report_hash[CURRENCY] = redis_data[CURRENCY]
    report_hash[EXCHANGE] = redis_data[EXCHANGE]
    report_hash[TIMEZONE_ID] = redis_data[TIMEZONE_ID]
    report_hash[COUNTRY_ID] = redis_data[COUNTRY_ID]

  end

  def add_admin_campaign_details(report_hash)
    add_campaign_details(report_hash)
    report_hash[COMPANY_ID] = "1"
    report_hash[TIMEZONE_ID] = "1"
    report_hash[COUNTRY_ID] = "1"
  end


  def add_content_provider_details(report_hash)
    if report_hash[COMPANY_ID]=="1"
      report_hash[CURRENCY_ID] = 1
      report_hash[CURRENCY] = CURRENCY_SYMBOL[1]
      report_hash[TIMEZONE_ID] = 1
      report_hash[EXCHANGE] = 1
      report_hash[COUNTRY_ID] = 1
    else
      content_provider=get_cp_details(report_hash[COMPANY_ID])
      report_hash[CURRENCY_ID] = content_provider[CURRENCY_ID]
      report_hash[CURRENCY] = CURRENCY_SYMBOL[content_provider[CURRENCY_ID]]
      report_hash[TIMEZONE_ID] = content_provider[TIMEZONE_ID]
      report_hash[EXCHANGE] = content_provider[EXCHANGE]
      report_hash[COUNTRY_ID] = content_provider[COUNTRY_ID]
    end

  end

  def add_msisdn_details(report_hash)

    campaign_data=get_campaign_details(report_hash[CAMPAIGN_ID])
    report_hash[CAMPAIGN_NAME]=campaign_data[CAMPAIGN_NAME]
    report_hash[COUNTRY]=COUNTRY_MAP[campaign_data[COUNTRY_ID]]
    report_hash[COUNTRY_ID] = campaign_data[COUNTRY_ID]
    report_hash[ACQUISITION_MODEL]=campaign_data[ACQUISITION_MODEL]
    report_hash[SERVICE_CODE]=""
    report_hash[LANDING_PAGE]=""

    #handling different acq-models
    if report_hash[ACQUISITION_MODEL]=="SMS"
      report_hash[SERVICE_CODE]=campaign_data[SERVICE_CODE]
    end
    if report_hash[ACQUISITION_MODEL]=="WAP"
      report_hash[LANDING_PAGE]=campaign_data[LANDING_PAGE]
    end
    report_hash[UNIT_CHARGE_DOLLAR]=Dollar.new(campaign_data[UNIT_CHARGE_DOLLAR])
    report_hash[UNIT_CHARGE_LOCAL]=Amount.new(campaign_data[CURRENCY],campaign_data[UNIT_CHARGE_LOCAL])
    report_hash[NET_CHARGE_DOLLAR]=Dollar.new(campaign_data[NET_CHARGE_DOLLAR])
    report_hash[NET_CHARGE_LOCAL]=Amount.new(campaign_data[CURRENCY],campaign_data[NET_CHARGE_LOCAL])
    report_hash[KEYWORD]=campaign_data[KEYWORD]
    report_hash[GATEWAY_SHARE]=Percentage.new(campaign_data[GATEWAY_SHARE])
    report_hash[OPERATOR_SHARE]=Percentage.new(campaign_data[OPERATOR_SHARE])
    report_hash[COMPANY_ID] = campaign_data[COMPANY_ID]

    content_provider=get_cp_details(report_hash[COMPANY_ID])
    report_hash[CURRENCY_ID] = content_provider[CURRENCY_ID]
    report_hash[CURRENCY] = CURRENCY_SYMBOL[content_provider[CURRENCY_ID]]
    report_hash[EXCHANGE] = content_provider[EXCHANGE]

    media_data =get_campaign_media(report_hash[CAMPAIGN_ID], report_hash[MEDIA_ID])
    report_hash[MEDIA_NAME] = media_data[MEDIA_NAME]
    report_hash[MEDIA_PAYOUT_DOLLAR] = Dollar.new(media_data[MEDIA_PAYOUT_DOLLAR])
    report_hash[MEDIA_PAYOUT_LOCAL] = Amount.new(report_hash[CURRENCY], media_data[MEDIA_PAYOUT_LOCAL])

    operator_data = get_operator_data(report_hash[OPERATOR_ID])
    report_hash[OPERATOR_NAME] = operator_data

  end

end
