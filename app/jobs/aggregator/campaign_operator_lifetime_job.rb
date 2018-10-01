class Aggregator::CampaignOperatorLifetimeJob < ApplicationJob

  @queue = :aggregator_campaign_operator_lifetime

  def self.perform(campaign_id,operator_id,date)

    @@logger_delegator.info("In Campaign Operator Lifetime Queue Jobs:"+campaign_id +"-"+operator_id)

    begin
      aggregate_campaign_operator_lifetime(campaign_id,operator_id,date)
    rescue => e
      puts e
      exception_job = {:action => "campaign_operator_lifetime_job", :exception => e.message ,
                       :backtrace => e.backtrace.inspect, :version=>"v1"}
      Resque.enqueue(ExceptionLogJob,exception_job)
    end
  end

  def self.aggregate_campaign_operator_lifetime(campaign_id,operator_id,date_string)

    date=date_string.to_date
    formatted_date= DateUtility.getUtcStartDateFromDate(date)
    #ids
    campaign_operator_lifetime_hash={}
    campaign_operator_lifetime_hash[DATE]=date
    campaign_operator_lifetime_hash[CAMPAIGN_ID]=campaign_id
    campaign_operator_lifetime_hash[OPERATOR_ID]=operator_id
    #details
    @@config_service.add_operator_details(campaign_operator_lifetime_hash)
    @@config_service.add_campaign_details(campaign_operator_lifetime_hash)
    @@report_service.get_zero_operator_data(campaign_operator_lifetime_hash[CURRENCY],campaign_operator_lifetime_hash)

    previous_day=DateUtility.getUtcStartDateFromDateAndDays(date,1)

    previous_lifetime_data=Campaign::OperatorLifetime.find_by_campaign_and_operator_and_date(campaign_operator_lifetime_hash[COMPANY_ID],
                                                                                             campaign_id,operator_id,previous_day)
    current_daily_data=Campaign::OperatorDaily.find_by_campaign_and_operator_and_date(campaign_id,operator_id,formatted_date)

    #delete current lifetime data
    Campaign::OperatorLifetime.delete_existing(campaign_id,operator_id,formatted_date)
    #make previous as inactive
    Campaign::OperatorLifetime.update_active(campaign_id,operator_id,formatted_date)

    if previous_lifetime_data && current_daily_data
      #stats
      @@stat_service.lifetime_operator_stats(current_daily_data,previous_lifetime_data,campaign_operator_lifetime_hash)
      #parsed finance stats
      @@stat_service.lifetime_operator_finance_stats(current_daily_data,previous_lifetime_data,campaign_operator_lifetime_hash)
      #deduced
      @@stat_service.deduced_operator_percentages(campaign_operator_lifetime_hash)

      #save new lifetime data for today
      Campaign::OperatorLifetime.new(campaign_operator_lifetime_hash).save
    else
      if current_daily_data
        Campaign::OperatorLifetime.new(current_daily_data.attributes.select{ |key, _| Campaign::OperatorLifetime.attribute_names.include? key }).save
      else
        #save zero life time data
        Campaign::OperatorLifetime.new(campaign_operator_lifetime_hash).save
      end

    end

  end

end