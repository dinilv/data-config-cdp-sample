class Accounter::CampaignJob < ApplicationJob

  @queue = :accounter_campaign

  def self.perform(campaign_id,month)
    @@logger_aggregator.info("In Accounter Campaign Billing Queue:" +company_id)
    begin

    rescue => e
      puts e
      exception_job = {:action => "accounter_campaign_job", :exception => e.message ,
                       :backtrace => e.backtrace.inspect,:version=>"v1"}
      Resque.enqueue(ExceptionLogJob,exception_job)
    end
  end
end