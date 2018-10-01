class Aggregator::MsisdnDailyJob < ApplicationJob

  @queue = :aggregator_msisdn_daily

  def self.perform(campaign_id,media_id,operator_id,msisdn,date)

    @@logger_aggregator.info("In MSISDN Daily Queue Jobs:"+msisdn+"-"+date)

    begin
      aggregate_msisdn_daily(campaign_id,media_id,operator_id,msisdn,date)
    rescue => e
      puts e,e.backtrace
      exception_job = {:action => "msisdn_daily_job", :exception => e.message , :backtrace => e.backtrace.inspect,:version=>"v1"}
      Resque.enqueue(ExceptionLogJob,exception_job)
    end

  end

  def self.aggregate_msisdn_daily(campaign_id,media_id,operator_id,msisdn,date_string)

    date=date_string.to_date
    formatted_date=DateUtility.getUtcStartDateFromDate(date)
    #ids
    msisdn_daily_hash={}
    msisdn_daily_hash[DATE]=date
    msisdn_daily_hash[CAMPAIGN_ID]=campaign_id
    msisdn_daily_hash[MEDIA_ID]=media_id
    msisdn_daily_hash[OPERATOR_ID]= operator_id
    msisdn_daily_hash[MSISDN]= msisdn

    #details
    @@config_service.add_msisdn_details(msisdn_daily_hash)
    @@report_service.get_zero_msisdn_data(msisdn_daily_hash[CURRENCY],msisdn_daily_hash)
    
    #aggregate media report for standard
    msisdn_date_filter = {MATCH_AGG_OP =>
                                { CAMPAIGN_ID_SHORT => campaign_id, MEDIA_ID_SHORT =>media_id, OPERATOR_ID_SHORT=> operator_id,
                                  MSISDN_SHORT => msisdn ,DATE_SHORT=>  formatted_date
                                }
    }

    standard_msisdn_report=Report::StandardMsisdnDaily.sum_daily([msisdn_date_filter,
                                                                @@report_service.get_msisdn_agg_group()])

    if standard_msisdn_report.count()>0
      standard_msisdn_report.each do |each_data|
        #stats
        @@stat_service.msisdn_stats(each_data,msisdn_daily_hash)
        #calculate finance related
        @@stat_service.calculate_msisdn_finance_stats(msisdn_daily_hash)
        @@stat_service.deduced_msisdn_finance(msisdn_daily_hash)
        @@stat_service.calculate_operator_finance_stats_converted(msisdn_daily_hash)
        @@stat_service.calculate_operator_finance_stats_dollar(msisdn_daily_hash)
        #deduced fields
        @@stat_service.deduced_msisdn_percentages(msisdn_daily_hash)
      end
    end

    #delete
    Msisdn::Daily.delete_existing(campaign_id,media_id,operator_id,msisdn,formatted_date)
    #store
    Msisdn::Daily.new(msisdn_daily_hash).save

  end


end