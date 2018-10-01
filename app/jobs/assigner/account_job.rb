class Assigner::AccountJob < ApplicationJob

  @queue = :delegator_account

  def self.perform

    @@logger_delegator.info("In Account Queue Jobs")

    begin
      queue_account_reports()
    rescue => e
      puts e
      exception_job = {:action => "delegator_account_job", :exception => e.message , :backtrace => e.backtrace.inspect, :version=>"v1"}
      Resque.enqueue(ExceptionLogJob,exception_job)
      raise Exception.new("Job Failed")
    end

  end

  def self.queue_account_reports

    # fetch all import account media queues
    account_medias=@@redis_service.get_sorted_set(REPORT_IMPORT_ACCOUNT_MEDIA)
    @@redis_service.del_key(REPORT_IMPORT_ACCOUNT_MEDIA)
    account_medias.each do |each|
      splitted=each.split("_")

      @@logger_delegator.info("account-media-date")
      @@logger_delegator.info(splitted)
      #add to queue
      if splitted[0].length >0
        Resque.enqueue(Aggregator::AccountMediaDailyJob,splitted[0],splitted[1],splitted[2])
        Resque.enqueue(Aggregator::AccountMediaLifetimeJob,splitted[0],splitted[1],splitted[2])
      end
    end

    # fetch all import account operator queues
    account_operators=@@redis_service.get_sorted_set(REPORT_IMPORT_ACCOUNT_OPERATORS)
    @@redis_service.del_key(REPORT_IMPORT_ACCOUNT_OPERATORS)
    account_operators.each do |each|
      splitted=each.split("_")
      @@logger_delegator.info("account-operator-date")
      @@logger_delegator.info(splitted)
      #add to queue
      if splitted[0].length >0
        Resque.enqueue(Aggregator::AccountOperatorDailyJob,splitted[0],splitted[1],splitted[2])
        Resque.enqueue(Aggregator::AccountOperatorLifetimeJob,splitted[0],splitted[1],splitted[2])
      end
    end
    # fetch all import account queues
    accounts=@@redis_service.get_sorted_set(REPORT_IMPORT_ACCOUNTS)
    @@redis_service.del_key(REPORT_IMPORT_ACCOUNTS)
    accounts.each do |each|
      splitted=each.split("_")
      @@logger_delegator.info("account-date")
      @@logger_delegator.info(splitted)
      #add to queue
      if splitted[0].length >0
        Resque.enqueue(Aggregator::AccountDailyJob,splitted[0],splitted[1])
        Resque.enqueue(Aggregator::AccountLifetimeJob,splitted[0],splitted[1])
      end
    end
  end
end