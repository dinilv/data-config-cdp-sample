class Aggregator::AccountLifetimeJob < ApplicationJob

  @queue = :aggregator_account_lifetime

  def self.perform(company_id,date)

    @@logger_aggregator.info("In Account Lifetime Queue:" +company_id)

    begin
      aggregate_account_lifetime(company_id,date)
    rescue => e
      puts e
      exception_job = {:action => "aggregator_account_lifetime_job", :exception => e.message ,
                       :backtrace => e.backtrace.inspect, :version=>"v1"}
      Resque.enqueue(ExceptionLogJob,exception_job)
    end
  end


  def self.aggregate_account_lifetime(company_id,date_string)

    date=date_string.to_date
    #ids
    account_lifetime_hash={}
    account_lifetime_hash[DATE]=date
    account_lifetime_hash[COMPANY_ID]=company_id

    #currency, exchange, timezone
    @@config_service.add_content_provider_details(account_lifetime_hash)
    @@report_service.get_zero_data(account_lifetime_hash[CURRENCY],account_lifetime_hash)

    #existing data
    formatted_date=DateUtility.getUtcStartDateFromDate(date)
    previous_day=DateUtility.getUtcStartDateFromDateAndDays(date,1)
    previous_lifetime_data=Account::SummaryLifetime.find_by_cp_and_date(company_id,previous_day)
    current_daily_data=Account::SummaryDaily.find_by_cp_and_date(company_id,formatted_date)

    #delete current lifetime data
    Account::SummaryLifetime.delete_existing(company_id,formatted_date)
    #make previous day as inactive
    Account::SummaryLifetime.update_active(company_id,previous_day)

    if previous_lifetime_data && current_daily_data
      #stats
      @@stat_service.lifetime_media_stats(current_daily_data,previous_lifetime_data,account_lifetime_hash)
      @@stat_service.lifetime_operator_stats(current_daily_data,previous_lifetime_data,account_lifetime_hash)
      #parsed finance stats
      @@stat_service.lifetime_media_finance_stats(current_daily_data,previous_lifetime_data,account_lifetime_hash)
      @@stat_service.lifetime_operator_finance_stats(current_daily_data,previous_lifetime_data,account_lifetime_hash)
      #deduced fields
      @@stat_service.deduced_media_stats_dollar(account_lifetime_hash)
      @@stat_service.deduced_media_stats_converted(account_lifetime_hash)
      #deduced percentages
      @@stat_service.deduced_media_percentages(account_lifetime_hash)
      @@stat_service.deduced_operator_percentages(account_lifetime_hash)
      #save new lifetime data for today
      Account::SummaryLifetime.new(account_lifetime_hash).save
    else
      if current_daily_data
        Account::SummaryLifetime.new(current_daily_data.attributes.select{ |key, _| Account::SummaryLifetime.attribute_names.include? key }).save
     else
        #save zero life time data
        Account::SummaryLifetime.new(account_lifetime_hash).save
      end
    end

  end
end