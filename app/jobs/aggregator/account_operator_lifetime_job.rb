class Aggregator::AccountOperatorLifetimeJob < ApplicationJob

  @queue = :aggregator_account_operator_lifetime

  def self.perform(company_id,operator_id,date)

    @@logger_aggregator.info("In Account Operator Lifetime Queue:" +company_id+"-"+operator_id)

    begin
      aggregate_account_operator_lifetime(company_id,operator_id,date)
    rescue => e
      puts e
      exception_job = {:action => "aggregator_account_operator_lifetime_job", :exception => e.message ,
                       :backtrace => e.backtrace.inspect, :version=>"v1"}
      Resque.enqueue(ExceptionLogJob,exception_job)
    end
  end

  def self.aggregate_account_operator_lifetime(company_id,operator_id,date_string)

    date=date_string.to_date
    formatted_date= DateUtility.getUtcStartDateFromDate(date)
    #ids
    account_operator_lifetime_hash={}
    account_operator_lifetime_hash[DATE]=date
    account_operator_lifetime_hash[OPERATOR_ID]=operator_id
    account_operator_lifetime_hash[COMPANY_ID]=company_id

    #currency, exchange, timezone
    @@config_service.add_content_provider_details(account_operator_lifetime_hash)
    @@config_service.add_operator_details(account_operator_lifetime_hash)
    @@report_service.get_zero_operator_data(account_operator_lifetime_hash[CURRENCY],account_operator_lifetime_hash)

    #existing data
    previous_day=DateUtility.getUtcStartDateFromDateAndDays(date,1)
    previous_lifetime_data=Account::OperatorLifetime.find_by_cp_and_operator_and_date(company_id,operator_id,formatted_date)
    current_daily_data=Account::OperatorDaily.find_by_cp_and_operator_and_date(company_id,operator_id,formatted_date)

    #delete current lifetime data
    Account::OperatorLifetime.delete_existing(company_id, operator_id,formatted_date)
    #make previous day as inactive
    Account::OperatorLifetime.update_active(company_id,operator_id,previous_day)

    if previous_lifetime_data && current_daily_data

      #stats
      @@stat_service.lifetime_operator_stats(current_daily_data,previous_lifetime_data,account_operator_lifetime_hash)
      #parsed finance stats
      @@stat_service.lifetime_operator_finance_stats(current_daily_data,previous_lifetime_data,account_operator_lifetime_hash)
      #deduced percentages
      @@stat_service.deduced_operator_percentages(account_operator_lifetime_hash)

      #save new lifetime data for today
      Account::OperatorLifetime.new(account_operator_lifetime_hash).save

    else
      if current_daily_data
        Account::OperatorLifetime.new(current_daily_data.
            attributes.select{ |key, _| Account::OperatorLifetime.attribute_names.include? key }).save
      else
        #save zero life time data
        Account::OperatorLifetime.new(account_operator_lifetime_hash).save
      end

    end

  end

end