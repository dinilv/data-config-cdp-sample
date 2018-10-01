class Aggregator::CampaignMediaDailyJob < ApplicationJob

  @queue = :aggregator_campaign_media_daily

  def self.perform(campaign_id,media_id,date)

    @@logger_aggregator.info("In Campaign media Daily Queue Jobs:"+campaign_id+"-"+media_id+"-"+date)

    begin
      aggregate_campaign_media_daily(campaign_id,media_id,date)
    rescue => e
      puts e, campaign_id,media_id,date, e.backtrace
      exception_job = {:action => "camapign_media_daily_job", :exception => e.message , :backtrace => e.backtrace.inspect,:version=>"v1"}
      Resque.enqueue(ExceptionLogJob,exception_job)
    end

  end

  def self.aggregate_campaign_media_daily(campaign_id,media_id,date_string)

    date=date_string.to_date
    formatted_date=DateUtility.getUtcStartDateFromDate(date)
    #ids
    campaign_media_daily_hash={}
    campaign_media_daily_hash[DATE]=date
    campaign_media_daily_hash[CAMPAIGN_ID]=campaign_id
    campaign_media_daily_hash[MEDIA_ID]=media_id
    #details
    @@stat_service.graph_stats_formatted(date,campaign_media_daily_hash)
    @@config_service.add_admin_campaign_details(campaign_media_daily_hash)
    @@config_service.add_campaign_media_details(campaign_media_daily_hash)
    @@report_service.get_zero_data(campaign_media_daily_hash[CURRENCY],campaign_media_daily_hash)
    
    #aggregate media report for standard
    campaign_media_date_filter = {MATCH_AGG_OP =>
                                { CAMPAIGN_ID_SHORT => campaign_id, MEDIA_ID_SHORT =>media_id,
                                  UTC_DATE_SHORT=>  formatted_date
                                }
    }

    standard_media_report=Report::StandardMediaDaily.sum_daily([campaign_media_date_filter,
                                                                @@report_service.get_media_agg_group])

    if standard_media_report.count()>0
      standard_media_report.each do |each_data|
        #stats
        @@stat_service.media_stats_formatted(each_data,campaign_media_daily_hash)
        #calculate finance related
        @@stat_service.calculate_media_finance_stats_dollar(campaign_media_daily_hash)
        @@stat_service.calculate_media_finance_stats_converted(campaign_media_daily_hash)
        #deduced fields
        @@stat_service.deduced_media_stats_converted(campaign_media_daily_hash)
        @@stat_service.deduced_media_percentages(campaign_media_daily_hash)
        #analysed fields
      end
    end

    #aggregate standard operator report
    standard_operator_report=Report::StandardOperatorDaily.sum_daily([campaign_media_date_filter,
                                                                      @@report_service.get_media_operator_agg_group()])

    if standard_operator_report.count()>0
      standard_operator_report.each do |each_data|
        #stats
        @@stat_service.operator_stats_formatted(each_data,campaign_media_daily_hash)
        #query subscribers
        @@stat_service.add_campaign_media_subscribers(campaign_media_daily_hash)
        #calculate finance
        @@stat_service.calculate_operator_finance_stats_converted(campaign_media_daily_hash)
        @@stat_service.calculate_operator_finance_stats_dollar(campaign_media_daily_hash)
        #deduced
        @@stat_service.deduced_operator_percentages(campaign_media_daily_hash)
        #analysed fields
      end
    end

    #deletion
    Campaign::MediaDaily.delete_existing(ADMIN_ACCOUNT ,campaign_id, media_id, formatted_date)
    #store
    Campaign::MediaDaily.new(campaign_media_daily_hash).save
    #assign admin account job
    @@redis_service.set_sorted_set(REPORT_IMPORT_ACCOUNTS,ADMIN_ACCOUNT+"_"+date_string,
                                   DateUtility.getDateScore(date_string))
    @@redis_service.set_sorted_set(REPORT_IMPORT_ACCOUNT_MEDIA,ADMIN_ACCOUNT+"_"+campaign_media_daily_hash[MEDIA_ID]+"_"+date_string,
                                   DateUtility.getDateScore(date_string))

  end


end