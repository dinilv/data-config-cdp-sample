class Aggregator::CampaignOperatorCpDailyJob < ApplicationJob

  @queue = :aggregator_campaign_operator_cp_daily

  def self.perform(campaign_id,operator_id,date)

    @@logger_delegator.info("In Campaign Operator CP Daily Queue Jobs:"+campaign_id +"-"+operator_id+"-"+date)

    begin
      aggregate_campaign_operator_daily(campaign_id,operator_id,date)
    rescue => e
      puts e
      exception_job = {:action => "campaign_cp_operator_daily_job", :exception => e.message ,
                       :backtrace => e.backtrace.inspect, :version=>"v1"}
      Resque.enqueue(ExceptionLogJob,exception_job)
    end

  end

  def self.aggregate_campaign_operator_daily(campaign_id,operator_id,date_string)

    date=date_string.to_date
    formatted_date=DateUtility.getUtcStartDateFromDate(date)

    #ids
    campaign_opertor_daily_hash={}
    campaign_opertor_daily_hash[DATE]=date
    campaign_opertor_daily_hash[CAMPAIGN_ID]=campaign_id
    campaign_opertor_daily_hash[OPERATOR_ID]=operator_id

    #details
    @@config_service.add_campaign_details(campaign_opertor_daily_hash)
    @@config_service.add_operator_details(campaign_opertor_daily_hash)
    @@report_service.get_zero_operator_data(campaign_opertor_daily_hash[CURRENCY],campaign_opertor_daily_hash)

    date_filter=formatted_date

    #check time zone is forward or backward
    splitted_hour_minutes= TIME_HOUR_MAP[campaign_opertor_daily_hash[TIMEZONE_ID]].split("_")
    hour=splitted_hour_minutes[0].to_i
    minutes=splitted_hour_minutes[1].to_i

    if hour >0
      start_date=DateUtility.getUtcDateByHourMinute(minutes,-hour,formatted_date)
      end_date=DateUtility.getForwardUtcDateByHourMinute(minutes,-hour,formatted_date)
      date_filter= { LESS_EQ_AGG_OP=> end_date,
                     GREATER_EQ_AGG_OP=> start_date}
      puts start_date,end_date
    elsif hour <0
      start_date=DateUtility.getBackwardSatrtUtcDateByHourMinute(minutes,-hour,formatted_date)
      end_date=DateUtility.getBackwardEndUtcDateByHourMinute(minutes,-hour,formatted_date)
      date_filter= { LESS_EQ_AGG_OP=> end_date,
                     GREATER_EQ_AGG_OP=> start_date}
      puts start_date,end_date
    end

    campaign_date_filter = {MATCH_AGG_OP =>
                                { CAMPAIGN_ID_SHORT => campaign_id,OPERATOR_ID_SHORT =>operator_id ,
                                  DATE_SHORT=> date_filter }
    }

    campaign_group= @@report_service.get_operator_agg_group()

    standard_operator_report=Report::StandardOperatorDaily.sum_daily([campaign_date_filter,
                                                                         campaign_group])

    puts campaign_date_filter
    if standard_operator_report.count()>0

      standard_operator_report.each do |each_data|

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

        Campaign::OperatorDaily.delete_existing(campaign_opertor_daily_hash[COMPANY_ID], campaign_id, operator_id,formatted_date)
        #save
        Campaign::OperatorDaily.new(campaign_opertor_daily_hash).save

        #assign lifetime job
        @@redis_service.set_sorted_set(REPORT_IMPORT_ACCOUNTS,campaign_opertor_daily_hash[COMPANY_ID]+"_"+date_string,
                                       DateUtility.getDateScore(date_string))
        @@redis_service.set_sorted_set(REPORT_IMPORT_ACCOUNT_OPERATORS,campaign_opertor_daily_hash[COMPANY_ID]+"_"+
            campaign_opertor_daily_hash[OPERATOR_ID]+"_"+date_string,DateUtility.getDateScore(date_string))

      end
    end

  end

end