class Aggregator::CampaignCpDailyJob < ApplicationJob

  @queue = :aggregator_campaign_cp_daily


  def self.perform(campaign_id,date)

    @@logger_aggregator.info("In Campaign CP Daily Queue Jobs:" + campaign_id.to_s)

    begin
      aggregate_campaign_cp_daily(campaign_id,date)
    rescue => e
      exception_job = {:action => "aggreagtor_cp_campaign_daily_job", :exception => e.message , :backtrace => e.backtrace.inspect, :version=>"v1"}
      Resque.enqueue(ExceptionLogJob,exception_job)
    end

  end


  def self.aggregate_campaign_cp_daily(campaign_id,date_string)

    date=date_string.to_date
    formatted_date=DateUtility.getUtcStartDateFromDate(date)
    #ids
    campaign_summary_daily_hash={}
    campaign_summary_daily_hash[DATE]=date
    campaign_summary_daily_hash[CAMPAIGN_ID]=campaign_id
    #details
    @@config_service.add_campaign_details(campaign_summary_daily_hash)
    @@report_service.get_zero_data(campaign_summary_daily_hash[CURRENCY],campaign_summary_daily_hash)

    campaign_date_filter = {MATCH_AGG_OP =>
                                { CAMPAIGN_ID_SHORT => campaign_id,
                                  DATE_SHORT=> formatted_date,
                                  COMPANY_ID_SHORT => campaign_summary_daily_hash[COMPANY_ID]
                                }
    }
    #aggregate campaign daily
    standard_campaign_report=Campaign::MediaDaily.sum_daily([campaign_date_filter,
                                                                        @@report_service.get_campaign_agg_group()])
    if standard_campaign_report.count()>0
      standard_campaign_report.each do |each_data|

        #stat
        @@stat_service.graph_stats_formatted(each_data,campaign_summary_daily_hash)
        @@stat_service.media_stats_formatted(each_data,campaign_summary_daily_hash)
        @@stat_service.operator_stats_formatted(each_data,campaign_summary_daily_hash)
        #parsed finance stats
        @@stat_service.parse_media_finance_stats(each_data,campaign_summary_daily_hash)
        @@stat_service.parse_operator_finance_stats(each_data,campaign_summary_daily_hash)
        #deduced fields
        @@stat_service.deduced_media_stats_dollar(campaign_summary_daily_hash)
        @@stat_service.deduced_media_stats_converted(campaign_summary_daily_hash)
        #deduced percentages
        @@stat_service.deduced_media_percentages(campaign_summary_daily_hash)
        @@stat_service.deduced_operator_percentages(campaign_summary_daily_hash)
        #analysed fields

        #delete existing data
        Campaign::SummaryDaily.delete_existing(campaign_summary_daily_hash[COMPANY_ID],campaign_id, formatted_date)
        #copy to mongo object and save
        Campaign::SummaryDaily.new(campaign_summary_daily_hash).save

      end
    end

  end


end
