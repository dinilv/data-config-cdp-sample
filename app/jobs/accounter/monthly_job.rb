class Accounter::MonthlyJob < ApplicationJob

  @queue = :accounter_monthly

  def self.perform(company_id,month)
    @@logger_aggregator.info("In Accounter Monthly Billing Queue:" +company_id)
    begin

    rescue => e
      puts e
      exception_job = {:action => "accounter_monthly_job", :exception => e.message ,
                       :backtrace => e.backtrace.inspect,:version=>"v1"}
      Resque.enqueue(ExceptionLogJob,exception_job)
    end
  end
end