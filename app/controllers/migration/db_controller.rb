class Migration::DbController < ApplicationController
  def campaign_ids
    campaign_ids=ContentProvider.all.pluck(:content_provider_id)
    campaign_ids.each do |key|
      set_campaign_ids(key)
    end
  end

  def create_cp_currency
    cp_details=ContentProvider.all.pluck(:content_provider_id,:currency_id)
    cp_details.each do |key,currency|
      currency=CURRENCY_SYMBOL[currency]
      set_cp_currency(key,currency)
    end
  end

  def campaign_details
    begin
      campaign_id=Campaign.all.pluck(:campaign_id)
      campaign_id.each do |key|
        set_campaign_details(key)
      end
      #render :json => {"message"=>"campaign_details migrated"}, :status => response[STATUS_CODE]
    rescue Exception => e
      puts e
    end
  end

  def cp_details
    currency_cp=ContentProvider.all.pluck(:content_provider_id)
    currency_cp.each do |key|
      set_cp_details(key)
    end
  end

  def campaign_media
    campaign_id=Campaign.all.pluck(:campaign_id,'campaign_media.media_id')
    campaign_id.each do |key,value|
      value.each do |v|
        set_campaign_media(key, v['media_id'])
      end
    end
    #render :json => {"message"=>"campaign_media_migrated"}, :status => response[STATUS_CODE]
  end

  def operator_data
    operator_id=Operator.all.pluck(:operator_id)
    operator_id.each do |key|
      set_operator_data(key)
    end
    #render :json => {"message"=>"operator migrated"}, :status => response[STATUS_CODE]
  end

  def media_data
    media_id=Media.all.pluck(:media_id)
    media_id.each do |key|
      set_media_data(key)
    end
    #render :json => {"message"=>"media migrated"}, :status => response[STATUS_CODE]
  end

  def all_migration
    @@redis_service.flush_db
    CurrencyExchangeJob.perform
    self.cp_details
    self.media_data
    self.operator_data
    self.campaign_media
    self.create_cp_currency
    self.campaign_details
    self.campaign_ids

    render :json => {"message"=>"all migrated"}, :status => response[STATUS_CODE]
  end


end
