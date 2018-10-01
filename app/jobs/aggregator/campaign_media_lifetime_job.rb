class Aggregator::CampaignMediaLifetimeJob < ApplicationJob

  @queue = :aggregator_campaign_media_lifetime

  def self.perform(campaign_id,media_id,date)

    @@logger_aggregator.info("In Campaign Media Lifetime Queue Jobs:" + campaign_id +"-"+media_id)

    begin
      aggregate_campaign_media_lifetime(campaign_id,media_id,date)
    rescue => e
      exception_job = {:action => "aggreagtor_campaign_media_lifetime_job", :exception => e.message ,
                       :backtrace => e.backtrace.inspect, :version=>"v1"}
      Resque.enqueue(ExceptionLogJob,exception_job)
    end

  end


  def self.aggregate_campaign_media_lifetime(campaign_id,media_id,date_string)
    date=date_string.to_date
    formatted_date= DateUtility.getUtcStartDateFromDate(date)
    #ids
    campaign_media_lifetime_hash={}
    campaign_media_lifetime_hash[DATE]=date
    campaign_media_lifetime_hash[CAMPAIGN_ID]=campaign_id
    campaign_media_lifetime_hash[MEDIA_ID]=media_id
    #details
    @@config_service.add_campaign_details(campaign_media_lifetime_hash)
    @@config_service.add_campaign_media_details(campaign_media_lifetime_hash)
    @@report_service.get_zero_data(campaign_media_lifetime_hash[CURRENCY],campaign_media_lifetime_hash)
    #existing data
    previous_day=DateUtility.getUtcStartDateFromDateAndDays(date,1)
    previous_lifetime_data=Campaign::MediaLifetime.find_by_campaign_and_media_and_date( campaign_id, media_id,previous_day)
    current_daily_data=Campaign::MediaDaily.find_by_campaign_and_media_and_date(campaign_media_lifetime_hash[COMPANY_ID] ,campaign_id, media_id,formatted_date)
    #delete current lifetime data
    Campaign::MediaLifetime.delete_existing(campaign_id,media_id,formatted_date)
    #make previous day as inactive
    Campaign::MediaLifetime.update_active(campaign_id,media_id,previous_day)

    if previous_lifetime_data && current_daily_data
      puts "both available"
      #stats
      @@stat_service.lifetime_media_stats(current_daily_data,previous_lifetime_data,campaign_media_lifetime_hash)
      @@stat_service.lifetime_operator_stats(current_daily_data,previous_lifetime_data,campaign_media_lifetime_hash)
      #parsed finance stats
      @@stat_service.lifetime_media_finance_stats(current_daily_data,previous_lifetime_data,campaign_media_lifetime_hash)
      @@stat_service.lifetime_operator_finance_stats(current_daily_data,previous_lifetime_data,campaign_media_lifetime_hash)
      #deduced fields
      @@stat_service.deduced_media_stats_dollar(campaign_media_lifetime_hash)
      @@stat_service.deduced_media_stats_converted(campaign_media_lifetime_hash)
      #deduced percentages
      @@stat_service.deduced_media_percentages(campaign_media_lifetime_hash)
      @@stat_service.deduced_operator_percentages(campaign_media_lifetime_hash)

      #save new lifetime data for today
      Campaign::MediaLifetime.new(campaign_media_lifetime_hash).save
    else
      if current_daily_data
        Campaign::MediaLifetime.new(current_daily_data.attributes.select{ |key, _| Campaign::MediaLifetime.attribute_names.include? key }).save
    else
        #save zero life time data
        Campaign::MediaLifetime.new(campaign_media_lifetime_hash).save
      end

    end

  end




end