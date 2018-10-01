class Assigner::CampaignJob < ApplicationJob

  @queue = :delegator_campaign

  def self.perform

    @@logger_delegator.info("In Campaign Queue Jobs")

    begin
      queue_campaign_reports()
    rescue => e
      puts e
      exception_job = {:action => "delegator_campaign_job", :exception => e.message , :backtrace => e.backtrace.inspect, :version=>"v1"}
      Resque.enqueue(ExceptionLogJob,exception_job)
      raise Exception.new("Job Failed")
    end

  end

  def self.queue_campaign_reports
    # fetch all campaign media queues
    campaign_medias =@@redis_service.get_sorted_set(REPORT_IMPORT_CAMPAIGN_MEDIA)
    campaign_medias.each do |each|
      splitted=each.split("_")
      @@logger_delegator.info("campaign-media-date")
      @@logger_delegator.info(splitted)
      #add to queue
      if splitted[0].length >0
      Resque.enqueue(Aggregator::CampaignMediaDailyJob,splitted[0],splitted[1],splitted[2])
      Resque.enqueue(Aggregator::CampaignMediaCpDailyJob,splitted[0],splitted[1],splitted[2])
      end
    end

    # fetch all campaign operator queues
    campaign_operators=@@redis_service.get_sorted_set(REPORT_IMPORT_CAMPAIGN_OPERATORS)
    campaign_operators.each do |each|
      splitted=each.split("_")
      @@logger_delegator.info("campaign-operator-date")
      @@logger_delegator.info(splitted)
      #add to queue
      if splitted[0].length >0
        Resque.enqueue(Aggregator::CampaignOperatorDailyJob,splitted[0],splitted[1],splitted[2])
        Resque.enqueue(Aggregator::CampaignOperatorCpDailyJob,splitted[0],splitted[1],splitted[2])
      end
    end
  end
end