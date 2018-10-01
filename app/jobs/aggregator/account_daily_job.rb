class Aggregator::AccountDailyJob < ApplicationJob

  @queue = :aggregator_account_daily

  def self.perform(company_id,date)

    @@logger_aggregator.info("In Account Daily Queue:" +company_id)

    begin
      account_summary_daily(company_id,date)
    rescue => e
      puts e
      exception_job = {:action => "aggregator_account_daily_job", :exception => e.message ,
                       :backtrace => e.backtrace.inspect,:version=>"v1"}
      Resque.enqueue(ExceptionLogJob,exception_job)
    end
  end

  def self.account_summary_daily(company_id,date_string)

    date=date_string.to_date
    formatted_date=DateUtility.getUtcStartDateFromDate(date)

    cp_date_filter = {MATCH_AGG_OP =>
                          { COMPANY_ID_SHORT => company_id,
                            DATE_SHORT=> formatted_date
                          }
    }

    account_media_report=Campaign::SummaryDaily.sum_daily([cp_date_filter,
                                                                           @@report_service.get_campaign_agg_group])

    if account_media_report.count()>0
      account_media_report.each do |each_data|

        #ids
        account_daily_hash={}
        account_daily_hash[DATE]=date
        account_daily_hash[COMPANY_ID]=company_id
        #currency, exchange, timezone
        @@config_service.add_content_provider_details(account_daily_hash)
        @@report_service.get_zero_data(account_daily_hash[CURRENCY],account_daily_hash)
        #add counts
        @@stat_service.add_account_counts(account_daily_hash)
        #stats
        @@stat_service.graph_stats_formatted(date,account_daily_hash)
        @@stat_service.media_stats_formatted(each_data,account_daily_hash)
        @@stat_service.operator_stats_formatted(each_data,account_daily_hash)
        #query subscribers
        @@stat_service.add_account_subscribers(account_daily_hash)
        #parsed finance stats
        @@stat_service.parse_media_finance_stats(each_data,account_daily_hash)
        @@stat_service.parse_operator_finance_stats(each_data,account_daily_hash)
        #deduced fields
        @@stat_service.deduced_media_stats_dollar(account_daily_hash)
        @@stat_service.deduced_media_stats_converted(account_daily_hash)
        #deduced percentages
        @@stat_service.deduced_media_percentages(account_daily_hash)
        @@stat_service.deduced_operator_percentages(account_daily_hash)
        #analysed fields

        #deletion
        Account::SummaryDaily.delete_existing(company_id,formatted_date)
        #store
        Account::SummaryDaily.new(account_daily_hash).save
      end
    end


  end
end