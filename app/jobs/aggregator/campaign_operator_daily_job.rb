class Aggregator::CampaignOperatorDailyJob < ApplicationJob

  @queue = :aggregator_campaign_operator_daily

  def self.perform(campaign_id,operator_id,date)

    @@logger_delegator.info("In Campaign Operator Daily Queue Jobs:"+campaign_id +"-"+operator_id+"-"+date)

    begin
      aggregate_campaign_operator_daily(campaign_id,operator_id,date)
    rescue => e
      puts e
      exception_job = {:action => "campaign_operator_daily_job", :exception => e.message ,
                       :backtrace => e.backtrace.inspect, :version=>"v1"}
      Resque.enqueue(ExceptionLogJob,exception_job)
    end

  end

  def self.aggregate_campaign_operator_daily(campaign_id,operator_id,date_string)

    date=date_string.to_date
    formatted_date=DateUtility.getUtcStartDateFromDate(date)

    campaign_date_filter = {MATCH_AGG_OP =>
                                { CAMPAIGN_ID_SHORT => campaign_id,OPERATOR_ID_SHORT =>operator_id ,
                                  UTC_DATE_SHORT=> formatted_date }
    }

    standard_operator_report=Report::StandardOperatorDaily.sum_daily([campaign_date_filter,
                                                                                 @@report_service.get_operator_agg_group()])

    if standard_operator_report.count()>0

      standard_operator_report.each do |each_data|
        #ids
        campaign_opertor_daily_hash={}
        campaign_opertor_daily_hash[DATE]=date
        campaign_opertor_daily_hash[CAMPAIGN_ID]=campaign_id
        campaign_opertor_daily_hash[OPERATOR_ID]=operator_id
        #details
        @@config_service.add_admin_campaign_details(campaign_opertor_daily_hash)
        @@config_service.add_operator_details(campaign_opertor_daily_hash)
        @@report_service.get_zero_operator_data(campaign_opertor_daily_hash[CURRENCY],campaign_opertor_daily_hash)
        #stats
        @@stat_service.graph_stats_formatted(each_data,campaign_opertor_daily_hash)
        @@stat_service.operator_stats_formatted(each_data,campaign_opertor_daily_hash)
        @@stat_service.add_campaign_operator_subscribers(campaign_opertor_daily_hash)
        #finance
        @@stat_service.calculate_operator_finance_stats_converted(campaign_opertor_daily_hash)
        @@stat_service.calculate_operator_finance_stats_dollar(campaign_opertor_daily_hash)
        #deduced
        @@stat_service.deduced_operator_percentages(campaign_opertor_daily_hash)
        @@stat_service.deduced_operator_percentages(campaign_opertor_daily_hash)

        Campaign::OperatorDaily.delete_existing(ADMIN_ACCOUNT, campaign_id, operator_id,formatted_date)
        #save
        Campaign::OperatorDaily.new(campaign_opertor_daily_hash).save
        #assign lifetime job
        @@redis_service.set_sorted_set(REPORT_IMPORT_ACCOUNTS,ADMIN_ACCOUNT+"_"+date_string,
                                       DateUtility.getDateScore(date_string))
        @@redis_service.set_sorted_set(REPORT_IMPORT_ACCOUNT_OPERATORS,ADMIN_ACCOUNT+"_"+campaign_opertor_daily_hash[OPERATOR_ID]+"_"+date_string,
                                       DateUtility.getDateScore(date_string))

      end
    end

  end

end