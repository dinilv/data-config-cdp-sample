class Assigner::MsisdnJob < ApplicationJob

  @queue = :delegator_msisdn

  def self.perform

    @@logger_delegator.info("In Msisdn Queue Jobs")

    begin
      queue_msisdn_reports()
    rescue => e
      puts e
      exception_job = {:action => "delegator_msisdn_job", :exception => e.message , :backtrace => e.backtrace.inspect, :version=>"v1"}
      Resque.enqueue(ExceptionLogJob,exception_job)
      raise Exception.new("Job Failed")
    end

  end

  def self.queue_msisdn_reports

    # fetch all imported msisdn data
    msisdns =@@redis_service.get_sorted_set(REPORT_IMPORT_MSISDN)
    @@redis_service.del_key(REPORT_IMPORT_MSISDN)
    msisdns.each do |each|
      splitted=each.split("_")
      @@logger_delegator.info("campaignID-mediaID-operatorID-msisdn-date")
      @@logger_delegator.info(splitted)
      #add to queue
      Resque.enqueue(Aggregator::MsisdnDailyJob,splitted[0],splitted[1],splitted[2],splitted[3],splitted[4])
      Resque.enqueue(Aggregator::MsisdnLifetimeJob,splitted[0],splitted[1],splitted[2],splitted[3],splitted[4])
    end

  end
end