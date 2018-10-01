class Aggregator::AccountMediaLifetimeJob < ApplicationJob

  @queue = :aggregator_account_media_lifetime

    def self.perform(company_id,media_id,date)

      @@logger_aggregator.info("In Account Media Lifetime Queue:" +company_id+"-"+media_id)

      begin
        aggregate_account_media_lifetime(company_id,media_id,date)
      rescue => e
        puts e
        exception_job = {:action => "aggregator_account_media_lifetime_job", :exception => e.message ,
                         :backtrace => e.backtrace.inspect,:version=>"v1"}
        Resque.enqueue(ExceptionLogJob,exception_job)
      end
    end

  def self.aggregate_account_media_lifetime(company_id,media_id,date_string)

    date=date_string.to_date
    formatted_date= DateUtility.getUtcStartDateFromDate(date)
    #ids
    account_media_lifetime_hash={}
    account_media_lifetime_hash[DATE]=date
    account_media_lifetime_hash[MEDIA_ID]=media_id
    account_media_lifetime_hash[COMPANY_ID]=company_id
    #currency, exchange, timezone
    @@config_service.add_content_provider_details(account_media_lifetime_hash)
    @@config_service.add_media_details(account_media_lifetime_hash)
    @@report_service.get_zero_data(account_media_lifetime_hash[CURRENCY],account_media_lifetime_hash)

    previous_day=DateUtility.getUtcStartDateFromDateAndDays(date,1)
    previous_lifetime_data=Account::MediaLifetime.find_by_cp_and_media_and_date( company_id, media_id,
                                                           previous_day)
    current_daily_data=Account::MediaDaily.find_by_cp_and_media_and_date( company_id, media_id,
                                                                          formatted_date)
    #delete current lifetime data
    Account::MediaLifetime.delete_existing(company_id, media_id,formatted_date)
    #make previous day as inactive
    Account::MediaLifetime.update_active(company_id,media_id,previous_day)

    if previous_lifetime_data && current_daily_data
      #stats
      @@stat_service.lifetime_media_stats(current_daily_data,previous_lifetime_data,account_media_lifetime_hash)
      @@stat_service.lifetime_operator_stats(current_daily_data,previous_lifetime_data,account_media_lifetime_hash)
      #parsed finance stats
      @@stat_service.lifetime_media_finance_stats(current_daily_data,previous_lifetime_data,account_media_lifetime_hash)
      @@stat_service.lifetime_operator_finance_stats(current_daily_data,previous_lifetime_data,account_media_lifetime_hash)
      #deduced fields
      @@stat_service.deduced_media_stats_dollar(account_media_lifetime_hash)
      @@stat_service.deduced_media_stats_converted(account_media_lifetime_hash)
      #deduced percentages
      @@stat_service.deduced_media_percentages(account_media_lifetime_hash)
      @@stat_service.deduced_operator_percentages(account_media_lifetime_hash)

      #save new lifetime data for today
      Account::MediaLifetime.new(account_media_lifetime_hash).save

    else
      if current_daily_data
        Account::MediaLifetime.new(current_daily_data.attributes.select{ |key, _| Account::MediaLifetime.attribute_names.include? key }).save
     else
        #save zero life time data
        Account::MediaLifetime.new(account_media_lifetime_hash).save
      end
    end

  end

end