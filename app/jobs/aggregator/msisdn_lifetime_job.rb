class Aggregator::MsisdnLifetimeJob < ApplicationJob

  @queue = :aggregator_msisdn_lifetime

  def self.perform(campaign_id,media_id,operator_id,msisdn,date)

    @@logger_aggregator.info("In Msisdn Lifetime Queue:" +msisdn)

    begin
      aggregate_msisdn_lifetime(campaign_id,media_id,operator_id,msisdn,date)
    rescue => e
      puts e
      exception_job = {:action => "aggregator_msisdn_lifetime_job", :exception => e.message ,
                       :backtrace => e.backtrace.inspect, :version=>"v1"}
      Resque.enqueue(ExceptionLogJob,exception_job)
    end
  end


  def self.aggregate_msisdn_lifetime(campaign_id,media_id,operator_id,msisdn,date_string)

    date=date_string.to_date
    #ids
    msisdn_lifetime_hash={}
    msisdn_lifetime_hash[DATE]=date
    msisdn_lifetime_hash[CAMPAIGN_ID]=campaign_id
    msisdn_lifetime_hash[MEDIA_ID]=media_id
    msisdn_lifetime_hash[OPERATOR_ID]= operator_id
    msisdn_lifetime_hash[MSISDN]= msisdn

    #currency, exchange, timezone
    @@config_service.add_msisdn_details(msisdn_lifetime_hash)

    #existing data
    formatted_date=DateUtility.getUtcStartDateFromDate(date)
    previous_day=DateUtility.getUtcStartDateFromDateAndDays(date,1)
    previous_lifetime_data= Msisdn::Lifetime.find_by_msidn(campaign_id,media_id,operator_id,msisdn,previous_day)
    current_daily_data= Msisdn::Daily.find_by_msidn(campaign_id,media_id,operator_id,msisdn,formatted_date)

    #delete current lifetime data
    Msisdn::Lifetime.delete_existing(campaign_id,media_id,operator_id,msisdn,formatted_date)

    #make previous day as inactive
    Msisdn::Lifetime.update_active(campaign_id,media_id,operator_id,msisdn,previous_day)

    if previous_lifetime_data && current_daily_data
      #stats
      @@stat_service.lifetime_msisdn_stats(current_daily_data,previous_lifetime_data,msisdn_lifetime_hash)
      @@stat_service.deduced_msisdn_finance(msisdn_lifetime_hash)
      @@stat_service.deduced_msisdn_percentages(msisdn_lifetime_hash)
      #save new lifetime data for today
      Msisdn::Lifetime.new(msisdn_lifetime_hash).save
    else
      if current_daily_data
        Msisdn::Lifetime.new(current_daily_data.attributes.select{ |key, _| Msisdn::Lifetime.attribute_names.include? key }).save
     else
        #save zero life time data
       Msisdn::Lifetime.new(msisdn_lifetime_hash).save
      end
    end

  end
end