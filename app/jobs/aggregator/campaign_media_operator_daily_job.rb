class Aggregator::CampaignMediaOperatorDailyJob < ApplicationJob

  @queue = :aggregator_campaign_media_daily

  def self.perform(campaign_id,media_id,date)

    @@logger_aggregator.info("In Campaign Media Operator Daily Queue Jobs:"+campaign_id+"-"+media_id)

    begin
      aggregate_campaign_media_operator_daily(campaign_id,media_id,date)
    rescue => e
      puts e
      exception_job = {:action => "camapign_media_operator_daily_job", :exception => e.message , :backtrace => e.backtrace.inspect,:version=>"v1"}
      Resque.enqueue(ExceptionLogJob,exception_job)
    end

  end

  def self.aggregate_campaign_media_operator_daily(campaign_id,media_id,date_string)

    date=date_string.to_date
    formatted_date= DateUtility.getUtcStartDateFromDate(date)
    current_campaign_media_daily_data=Campaign::MediaDaily.find_by_campaign_and_media_and_date( campaign_id, media_id,formatted_date)

    #copy current data
    campaign_media_operator_model=Campaign::MediaOperatorDaily.new(current_campaign_media_daily_data.attributes.select{ |key, _| Campaign::MediaOperatorDaily.attribute_names.include? key })

    #aggregate media report for standard
    campaign_media_date_filter = {MATCH_AGG_OP =>
                                      { CAMPAIGN_ID_SHORT => campaign_id, MEDIA_ID_SHORT =>media_id,
                                        UTC_DATE_SHORT=>  formatted_date
                                      }
    }

    #aggregate standard operator report
    standard_operator_report=Report::StandardOperatorDaily.sum_daily([campaign_media_date_filter,
                                                                      @@report_service.get_campaign_media_operator_agg_group()])


    media_operator_hash={}
    if standard_operator_report.count()>0
      standard_operator_report.each do |each_data|
        #stats
        @@stat_service.operator_stats_formatted(each_data,media_operator_hash)
        #calculate finance
        @@stat_service.calculate_operator_finance_stats_converted(media_operator_hash)
        @@stat_service.calculate_operator_finance_stats_dollar(media_operator_hash)
        #deduced
        @@stat_service.deduced_operator_percentages(media_operator_hash)
        #analysed fields
      end
    end

    #deletion
    Campaign::MediaDaily.delete_existing( campaign_id, media_id, formatted_date)
    #store
    Campaign::MediaDaily.new(campaign_media_daily_hash).save

  end


end