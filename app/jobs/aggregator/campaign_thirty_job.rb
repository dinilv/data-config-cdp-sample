class Aggregator::CampaignThirtyJob < ApplicationJob

  @queue = :aggregator_campaign_thirty

  def self.perform(campaign_id,date)

    @@logger_delegator.info("In Campaign Thirty Queue Jobs:"+campaign_id )

    begin
      aggregate_campaign_thirty(campaign_id,date)
    rescue => e
      puts e
      exception_job = {:action => "campaign_thirty_job", :exception => e.message ,
                       :backtrace => e.backtrace.inspect, :version=>"v1"}
      Resque.enqueue(ExceptionLogJob,exception_job)
    end
  end



def self.aggregate_campaign_thirty(campaign_id,date_string)

  date=date_string.to_date
  #ids
  campaign_summary_thirty_hash={}
  campaign_summary_thirty_hash[DATE]=date
  campaign_summary_thirty_hash[CAMPAIGN_ID]=campaign_id
  #details
  @@config_service.add_campaign_details(campaign_summary_thirty_hash)
  @@report_service.get_zero_data(campaign_summary_thirty_hash[CURRENCY],campaign_summary_thirty_hash)

  #aggregate campaign thirty
  start_thirty_date=DateUtility.getUtcStartDateFromDateAndDays(date,30)
  end_thirty_date=DateUtility.getUtcStartDateFromDate(date)

  filter = {MATCH_AGG_OP =>
                {
                    COMPANY_ID_SHORT => campaign_summary_thirty_hash[COMPANY_ID],
                    CAMPAIGN_ID_SHORT => campaign_id,
                   DATE_SHORT=> { GREATER_EQ_AGG_OP => start_thirty_date, LESS_EQ_AGG_OP => end_thirty_date }
                }
  }

  standard_campaign_thirty_report=Campaign::SummaryDaily.sum_daily([filter,@@report_service.get_campaign_agg_group()])

  #make previous day as inactive
  Campaign::SummaryThirty.update_active(campaign_id,end_thirty_date)

  if standard_campaign_thirty_report.count()>0
    standard_campaign_thirty_report.each do |each_data|

      #stats
      @@stat_service.media_stats_formatted(each_data,campaign_summary_thirty_hash)
      @@stat_service.operator_stats_formatted(each_data,campaign_summary_thirty_hash)
      @@stat_service.add_campaign_thirty_subscribers(campaign_summary_thirty_hash)
      #parsed finance stats
      @@stat_service.parse_media_finance_stats(each_data,campaign_summary_thirty_hash)
      @@stat_service.parse_operator_finance_stats(each_data,campaign_summary_thirty_hash)
      #deduced fields
      @@stat_service.deduced_media_stats_dollar(campaign_summary_thirty_hash)
      @@stat_service.deduced_media_stats_converted(campaign_summary_thirty_hash)
      #deduced percentages
      @@stat_service.deduced_media_percentages(campaign_summary_thirty_hash)
      @@stat_service.deduced_operator_percentages(campaign_summary_thirty_hash)

      # delete existing data
      Campaign::SummaryThirty.delete_existing(campaign_id,end_thirty_date)
      #copy to mongo object and save
      Campaign::SummaryThirty.new(campaign_summary_thirty_hash).save

    end
  end
  end



end
