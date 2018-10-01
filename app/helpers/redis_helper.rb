module RedisHelper
  include ConfigConstants
  include DbConstants
  include ReportImportConstants
  include DropdownsConstants
  @@redis_service=Redis::RedisDaoService.new
#set redis data
  def set_campaign_ids(cmp_id)
    campaigns = Campaign.where(content_provider_id: cmp_id)
    response_array = []
    campaigns.each do |campaign|
      campaign_hash = campaign['campaign_id']
      response_array << campaign_hash
    end
    response = response_array.join(",")
    @@redis_service.set_hashset(CAMPAIGN_IDS, cmp_id, response)
  end

  def get_campaign_ids(cmp_id)
    @@redis_service.get_hashset_data(CAMPAIGN_IDS,cmp_id)
  end


  def set_campaign_media(campaign_id, media_id)
    cm_details = {}
    campaign = Campaign.find_by(campaign_id: campaign_id)
    campaign = campaign.campaign_media.find_by(media_id: media_id)
    media = Media.find_by(media_id: media_id)
    Media_key.each do |key, media|
      cm_details[media] = campaign[media]
    end
    cm_details[MEDIA_NAME] = media[MEDIA_NAME]
    key = "campaign_media_" + campaign_id.to_s + "_" + media_id.to_s
    @@redis_service.del_key(key)
    @@redis_service.set_json_data(key, cm_details.to_json)

  end

  def set_campaign_details(campaign_id)
    campaign_details = {}
    campaign = Campaign.find_by(campaign_id: campaign_id)
    campaign_details[COMPANY_ID] = campaign[COMPANY_ID].to_s
    campaign_details[CAMPAIGN_ID] = campaign[CAMPAIGN_ID]
    campaign_details[CAMPAIGN_NAME] = campaign[CAMPAIGN_NAME]
    campaign_details[OPERATOR_IDS] = campaign.campaign_operator.all.pluck(:operator_id).join(",")
    campaign_details[COUNTRY_ID] = campaign[COUNTRY_ID]
    campaign_details[MT_DAILY_APPROVED] = campaign[MT_DAILY_APPROVED]
    category = campaign[CATEGORY]
    campaign_details[CATEGORY] = CAMPAIGN_TYPES[category]
    acquisition_model = campaign[ACQUISITION_MODEL]
    campaign_details[ACQUISITION_MODEL] = CAMPAIGN_ACQUISITION_TYPE[acquisition_model]
    campaign_details[LANDING_PAGE] = campaign[LANDING_PAGE]
    campaign_details[KEYWORD] = campaign[KEYWORD]
    campaign_details[SERVICE_CODE] = campaign[SERVICE_CODE]
    campaign_details[UNIT_CHARGE_DOLLAR] = campaign[UNIT_CHARGE_DOLLAR]
    campaign_details[UNIT_CHARGE_LOCAL] = campaign[UNIT_CHARGE_LOCAL]
    campaign_details[NET_CHARGE_DOLLAR] = campaign[NET_CHARGE_DOLLAR]
    campaign_details[NET_CHARGE_LOCAL] = campaign[NET_CHARGE_DOLLAR]
    if Company.where(company_id: campaign[COMPANY_ID]).exists?
      company_details = Company.find_by(company_id: campaign[COMPANY_ID])
      campaign_details[CURRENCY_ID] = company_details[CURRENCY_ID]
      campaign_details[CURRENCY] = CURRENCY_SYMBOL[company_details[CURRENCY_ID]]
      campaign_details[TIMEZONE_ID] = company_details[TIMEZONE_ID]
      campaign_details[OFFSET] = TIME_OFFSET[content_provider[TIMEZONE_ID]]
      campaign_details[EXCHANGE] = get_currency(company_details[CURRENCY_ID]).to_f
    else
      content_provider = ContentProvider.find_by(content_provider_id: campaign[COMPANY_ID])
      campaign_details[CURRENCY_ID] = content_provider[CURRENCY_ID]
      campaign_details[CURRENCY] = CURRENCY_SYMBOL[content_provider[CURRENCY_ID]]
      campaign_details[TIMEZONE_ID] = content_provider[TIMEZONE_ID]
      campaign_details[EXCHANGE] = get_currency(content_provider[CURRENCY_ID]).to_f
      campaign_details[OFFSET] = TIME_OFFSET[content_provider[TIMEZONE_ID]]
    end
    campaign_details[GATEWAY_SHARE] = campaign[GATEWAY_SHARE]
    campaign_details[OPERATOR_SHARE] = campaign[OPERATOR_SHARE]
    campaign_details[STATUS] = campaign[STATUS]
    operator_status = campaign.campaign_operator.where(status: 1).count
    media_status = campaign.campaign_media.where(status: 1).count
    media_ids = campaign.campaign_media.where(status: 1).all.pluck(:media_id)
    operator_ids = campaign.campaign_operator.where(status: 1).all.pluck(:operator_id)
    operator_hash = []
    operator_ids.each do |key|
      operator_hash << self.get_operator_data(key)
    end
    media_hash = []
    media_ids.each do |key|
      media_hash << self.get_media_data(key)
    end
    campaign_details[LIVE_OPERATOR_COUNT] = operator_status
    campaign_details[LIVE_MEDIA_COUNT] = media_status
    campaign_details[MEDIA_IDS] = media_ids.join(",")
    campaign_details[OPERATOR_IDS] = operator_ids.join(",")
    campaign_details[LIVE_OPERATORS] = operator_hash.join("/")
    campaign_details[LIVE_MEDIA] = media_hash.join("/")
    key = 'campaign_details_' + campaign_id.to_s
    @@redis_service.del_key(key)
    @@redis_service.set_json_data(key, campaign_details.to_json)
  end

  def set_user_data (user_data,token)
    @@redis_service.set_json_data("token:" + token, user_data.to_json)

  end
  def get_user_data(token)
    JSON.parse(@@redis_service.get_json_data("token:" + token))
  end

  def set_cp_details(cy)
    cp_details={}
    if Company.where(company_id: cy).exists?
      company_details = Company.find_by(company_id: cy)
      cp_details[CURRENCY_ID] = company_details[CURRENCY_ID]
      cp_details[CURRENCY] = CURRENCY_SYMBOL[company_details[CURRENCY_ID]]
      cp_details[TIMEZONE_ID] = company_details[TIMEZONE_ID]
      cp_details[EXCHANGE] = get_currency(company_details[CURRENCY_ID]).to_f
      cp_details[OFFSET] = TIME_OFFSET[content_provider[TIMEZONE_ID]]
      cp_details[COUNTRY_ID] = company_details[COUNTRY_ID]
    else
      content_provider = ContentProvider.find_by(content_provider_id: cy)
      cp_details[CURRENCY_ID] = content_provider[CURRENCY_ID]
      cp_details[CURRENCY] = CURRENCY_SYMBOL[content_provider[CURRENCY_ID]]
      cp_details[TIMEZONE_ID] = content_provider[TIMEZONE_ID]
      cp_details[EXCHANGE] = get_currency(content_provider[CURRENCY_ID]).to_f
      cp_details[OFFSET] = TIME_OFFSET[content_provider[TIMEZONE_ID]]
      cp_details[COUNTRY_ID] = content_provider[COUNTRY_ID]
    end
    key='content_provider_details_'+cy.to_s
    @@redis_service.set_json_data(key, cp_details.to_json)

  end

  def set_media_data(media_id)
    media_details = []
    media = Media.find_by(media_id: media_id)
    media_details[0] = media['media_name']
    @@redis_service.set_hashset(MEDIA, media_id, media_details.join(","))
  end

  def set_operator_data(operator_id)
    operators = Operator.find_by(operator_id: operator_id)
    operator_details = []
    operator_details = operators['operator_name']
    @@redis_service.set_hashset(OPERATORS, operator_id, operator_details)
  end
  def set_currency_symbol
    CURRENCY_CODE.each do |key, value|
      RedisConfig.getConnection.hset('currency_symbol', key, value)
    end

  end

  def set_active_token(token)
    item="token:" + token
    RedisConfig.getConnection.lpush(LIST_KEY, item)
    # insert_status =  RedisConfig.getConnection.linsert(LIST_KEY, 'before', item, item)
    # if insert_status == 0
    #   RedisConfig.getConnection.lpush(LIST_KEY, item)
    # else
    #   RedisConfig.getConnection.lrem(LIST_KEY, 1, item)
    # end
  end
  def get_cp_details(cid)
    key='content_provider_details_'+cid.to_s
    JSON.parse(RedisConfig.getConnection.get(key))
  end

  def get_campaign_details(campaign_id)
    key = 'campaign_details_' + campaign_id.to_s
    JSON.parse(@@redis_service.get_json_data(key))
  end

  def get_campaign_media(campaign_id, media_id)
    key = "campaign_media_" + campaign_id.to_s + "_" + media_id.to_s
    JSON.parse(@@redis_service.get_json_data(key))
  end

  def get_operator_data(operator_id)
    RedisConfig.getConnection.hget(OPERATORS, operator_id)
  end

  def get_media_data(media_id)
    RedisConfig.getConnection.hget(MEDIA, media_id)
  end

  def set_login_expire(token)
    RedisConfig.getConnection.expire("token:" + token, 2.hours)
  end

  def get_active_token
    RedisConfig.getConnection.lrange("active_token", 0, -1)
  end

  def set_currency(key, value)
    @@redis_service.set_hashset('currency_exchange', key, value)
  end

  def get_currency(key)
    RedisConfig.getConnection.hget('currency_exchange', key)
  end

  def get_currency_symbol(key)
    RedisConfig.getConnection.hget('currency_symbol', key)
  end


  def set_cp_currency(key, value)
    RedisConfig.getConnection.hset('cp_currency', key, value)
  end

end