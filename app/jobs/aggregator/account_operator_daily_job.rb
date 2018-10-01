class Aggregator::AccountOperatorDailyJob < ApplicationJob

  @queue = :aggregator_account_operator_daily

  def self.perform(company_id,operator_id,date)

    @@logger_aggregator.info("In Account Operator Daily Queue:" +company_id+"-"+operator_id)

    begin
      aggregate_account_operator_daily(company_id,operator_id,date)
    rescue => e
      puts e
      exception_job = {:action => "aggregator_account_operator_daily_job", :exception => e.message ,
                       :backtrace => e.backtrace.inspect,:version=>"v1"}
      Resque.enqueue(ExceptionLogJob,exception_job)
    end
  end

  def self.aggregate_account_operator_daily(company_id,operator_id,date_string)

    date=date_string.to_date
    formatted_date= DateUtility.getUtcStartDateFromDate(date)
    cp_operator_date_filter = {MATCH_AGG_OP =>
                          { COMPANY_ID_SHORT => company_id,OPERATOR_ID_SHORT=>operator_id,
                            DATE_SHORT=>  formatted_date
                          }
    }

    account_operator_report=Campaign::OperatorDaily.sum_daily([cp_operator_date_filter,
                                                                    @@report_service.get_operator_daily_agg_group()])

    if account_operator_report.count()>0
      account_operator_report.each do |each_data|
        #ids
        account_operator_daily_hash={}
        account_operator_daily_hash[DATE]=date
        account_operator_daily_hash[OPERATOR_ID]=operator_id
        account_operator_daily_hash[COMPANY_ID]=company_id
        #currency, exchange, timezone
        @@config_service.add_content_provider_details(account_operator_daily_hash)
        @@config_service.add_operator_details(account_operator_daily_hash)
        @@report_service.get_zero_operator_data(account_operator_daily_hash[CURRENCY],account_operator_daily_hash)
        #stats
        @@stat_service.graph_stats_formatted(date,account_operator_daily_hash)
        @@stat_service.operator_stats_formatted(each_data,account_operator_daily_hash)
        #query subscribers
        @@stat_service.add_account_operator_subscribers(account_operator_daily_hash)
        #add counts
        @@stat_service.add_account_operator_counts(account_operator_daily_hash)
        #parsed finance stats
        @@stat_service.parse_operator_finance_stats(each_data,account_operator_daily_hash)
        #deduced percentages
        @@stat_service.deduced_operator_percentages(account_operator_daily_hash)
        #analysed fields

        #delete existing data
        Account::OperatorDaily.delete_existing(company_id, operator_id,formatted_date)
        #copy to mongo object and save
        Account::OperatorDaily.new(account_operator_daily_hash).save

      end
    end
  end
end