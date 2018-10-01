class Imports::ZeroDataJob < ApplicationJob

  def self.perform
    begin
      now=Time.now.utc()
      now_formatted=DateUtility.getUtcStartDateFromDate(now)
      create_zero_data(now_formatted)
    rescue => e
      puts e
      exception_job = {:action => "zero_data_job", :exception => e.message , :backtrace => e.backtrace.inspect, :version=>"v1"}
      Resque.enqueue(ExceptionLogJob,exception_job)
      raise Exception.new("Job Failed")
    end
  end

  def self.create_zero_data(now_formatted)

    #get content providers unique currency_ids
    currency_ids=ContentProvider.all.distinct(CURRENCY_ID)
    #data to load

    #loop through it
    currency_ids.each do |currency_id|
      #currency symbol
      currency=CURRENCY_SYMBOL[currency_id]
      if currency


      graph_id=now_formatted.day.to_s + " " + now_formatted.strftime("%b")

      #delete if exists
      Campaign::SummaryDaily.where(CURRENCY_ID_SHORT=>currency_id,
                                   GRAPH_ID_SHORT=>graph_id,DATE_SHORT=>now_formatted,ZERO_DATA_TAG_SHORT=>true ).delete
      Campaign::MediaDaily.where(CURRENCY_ID_SHORT=>currency_id,
                                 GRAPH_ID_SHORT=>graph_id,DATE_SHORT=>now_formatted,ZERO_DATA_TAG_SHORT=>true).delete
      Campaign::OperatorDaily.where(CURRENCY_ID_SHORT=>currency_id,
                                    GRAPH_ID_SHORT=>graph_id,DATE_SHORT=>now_formatted,ZERO_DATA_TAG_SHORT=>true).delete
      Account::OperatorDaily.where(CURRENCY_ID_SHORT=>currency_id,
                                   GRAPH_ID_SHORT=>graph_id,DATE_SHORT=>now_formatted,ZERO_DATA_TAG_SHORT=>true).delete
      Account::MediaDaily.where(CURRENCY_ID_SHORT=>currency_id,
                                GRAPH_ID_SHORT=>graph_id,DATE_SHORT=>now_formatted,ZERO_DATA_TAG_SHORT=>true).delete
      Account::SummaryDaily.where(CURRENCY_ID_SHORT=>currency_id,
                                  GRAPH_ID_SHORT=>graph_id,DATE_SHORT=>now_formatted,ZERO_DATA_TAG_SHORT=>true).delete

      zero_data={}
      zero_data[ZERO_DATA_TAG]=true
      zero_data[GRAPH_ID]=graph_id
      zero_data[CURRENCY_ID]=currency_id
      zero_data[DATE]=now_formatted
      @@report_service.get_zero_data(currency,zero_data)
      @@stat_service.graph_stats_formatted(now_formatted,zero_data)
      Campaign::SummaryDaily.new(zero_data).save
      Campaign::MediaDaily.new(zero_data).save

      #for operator
      zero_operator_data={}
      zero_operator_data[ZERO_DATA_TAG]=true
      zero_operator_data[GRAPH_ID]= graph_id
      zero_operator_data[CURRENCY_ID]=currency_id
      zero_operator_data[DATE]=now_formatted
      @@report_service.get_zero_operator_data(currency,zero_operator_data)
      @@stat_service.graph_stats_formatted(now_formatted,zero_operator_data)
      Campaign::OperatorDaily.new(zero_operator_data).save
      Account::OperatorDaily.new(zero_operator_data).save

      #for operator
      zero_account_data={}
      zero_account_data[ZERO_DATA_TAG]=true
      zero_account_data[GRAPH_ID]= graph_id
      zero_account_data[CURRENCY_ID]=currency_id
      zero_account_data[DATE]=now_formatted
      @@report_service.get_zero_account_data(currency,zero_account_data)
      @@stat_service.graph_stats_formatted(now_formatted,zero_account_data)
      Account::MediaDaily.new(zero_account_data).save
      Account::SummaryDaily.new(zero_account_data).save
      end
    end

  end
end