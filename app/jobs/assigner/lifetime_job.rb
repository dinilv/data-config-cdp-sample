class Assigner::LifetimeJob < ApplicationJob

  @queue = :delegator_lifetime

  def self.perform

    @@logger_delegator.info("In Life Time Queue Jobs")

    begin
      queue_lifetime_reports()
    rescue => e
      puts e
      exception_job = {:action => "delegator_lifetime_job", :exception => e.message , :backtrace => e.backtrace.inspect, :version=>"v1"}
      Resque.enqueue(ExceptionLogJob,exception_job)
      raise Exception.new("Job Failed")
    end

  end

  def self.queue_lifetime_reports

    # fetch all campaign media queues
    campaign_medias =@@redis_service.get_sorted_set(REPORT_IMPORT_CAMPAIGN_MEDIA)
    @@redis_service.del_key(REPORT_IMPORT_CAMPAIGN_MEDIA)
    campaign_medias.each do |each|
      splitted=each.split("_")
      @@logger_delegator.info("campaign-media-date")
      @@logger_delegator.info(splitted)
      #add to queue
      if splitted[0].length >0
        Resque.enqueue(Aggregator::CampaignMediaLifetimeJob,splitted[0],splitted[1],splitted[2])
      end
    end

    # fetch all campaign operator queues
    campaign_operators=@@redis_service.get_sorted_set(REPORT_IMPORT_CAMPAIGN_OPERATORS)
    @@redis_service.del_key(REPORT_IMPORT_CAMPAIGN_OPERATORS)
    campaign_operators.each do |each|
      splitted=each.split("_")
      @@logger_delegator.info("campaign-operator-date")
      @@logger_delegator.info(splitted)
      #add to queue
      if splitted[0].length >0
        Resque.enqueue(Aggregator::CampaignOperatorLifetimeJob,splitted[0],splitted[1],splitted[2])
      end
    end
    # fetch all campaign queues
    campaigns=@@redis_service.get_sorted_set(REPORT_IMPORT_CAMPAIGNS)
    @@redis_service.del_key(REPORT_IMPORT_CAMPAIGNS)
    campaigns.each do |each|
      splitted=each.split("_")
      @@logger_delegator.info("campaign-date")
      @@logger_delegator.info(splitted)
      #add to queue
      if splitted[0].length >0
        Resque.enqueue(Aggregator::CampaignDailyJob,splitted[0],splitted[1])
        Resque.enqueue(Aggregator::CampaignCpDailyJob,splitted[0],splitted[1])
        Resque.enqueue(Aggregator::CampaignLifetimeJob,splitted[0],splitted[1])
        Resque.enqueue(Aggregator::CampaignThirtyJob,splitted[0],splitted[1])
      end
    end
  end
end