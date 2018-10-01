class Imports::MsisdnJob < ApplicationJob


  def self.perform
    begin
      i=0
      startDate= DateUtility.getUtcStartDateFromDate(Time.now.utc)
      startDateFormatted=Time.now.utc.strftime("%d/%m/%Y")

      #delete any entries for the import day
      (Report::StandardMsisdnDaily).where({:d=>startDate}).delete

      loop do
        i=i+1
        link="http://api.iiris.io/cmp/msisdn/report?date=<STARTDATE>&limit=1000&sort=offer_id&offset=<OFFSET>"
        link=link.gsub! "<OFFSET>",i.to_s
        link=link.gsub! "<STARTDATE>",startDateFormatted

        uri = URI(link)
        resp = Net::HTTP.get_response(uri)
        hash = JSON(resp.body)

        if hash["data"]
          msisdn_import_data(hash["data"])
        else
          @@logger_import.info("No data found")
          break
        end
        break
      end
    rescue => e
      exception_job = {:action => "msisdn_job", :exception => e.message , :backtrace => e.backtrace.inspect }
      Resque.enqueue(ExceptionLogJob,exception_job)
    end
  end

  def self.custom(date)
    begin
      i=0
      startDate= DateUtility.getUtcStartDateFromDate(date.to_date)
      (Report::StandardMsisdnDaily).collection.delete({:d=>startDate})
      loop do
        i=i+1
        link="http://api.iiris.io/cmp/msisdn/report?date="+date+"&limit=1000&sort=offer_id&offset=<OFFSET>"
        newlink=link.gsub! "<OFFSET>",i.to_s
        uri = URI(link)
        resp = Net::HTTP.get_response(uri)
        hash = JSON(resp.body)

        if hash["data"]
          msisdn_import_data(hash["data"])
        else
          @@logger_import.info("No data found")
          break
        end
        break
      end
    rescue => e
      puts e,e.backtrace
      exception_job = {:action => "msisdn_cusotm_job", :exception => e.message , :backtrace => e.backtrace.inspect }
      Resque.enqueue(ExceptionLogJob,exception_job)
    end
  end

  def self.msisdn_import_data(data)

    report_array=[]
    data.each do |datarow|
      report_hash={}
      #parse data
      report_hash[DATE_SHORT]=datarow[DATE].to_date
      report_hash[CAMPAIGN_ID_SHORT]=datarow[OFFER_ID]
      report_hash[MEDIA_ID_SHORT]=datarow[AFFILIATE_ID]
      report_hash[OPERATOR_ID_SHORT]=datarow[OPERATOR_ID]
      report_hash[MSISDN_SHORT]=datarow[MSISDN]
      report_hash[SUBSCRIPTIONS_SHORT]=datarow[SUBSCRIPTION_POSTBACK]
      report_hash[UN_SUBSCRIPTIONS_SHORT]=datarow[UN_SUBSCRIPTION_POSTBACK]
      report_hash[MT_SENT_SHORT]=datarow[MT_SENT]
      report_hash[MT_DELIVERED_SHORT]=datarow[DR_DELIVERED]
      report_hash[MT_FAIL_SHORT]=datarow[DR_FAIL]
      report_hash[MT_SUCCESS_SHORT]=datarow[MT_SUCCESS]
      report_hash[MT_UNKNOWN_SHORT]=datarow[DR_UNKNOWN]
      report_hash[MT_SENT_BY_OPERATOR_SHORT]=datarow[MT_SENT_BY_OPERATOR]
      #add to array
      #(Report::StandardMsisdnDaily).new(report_hash).save
      report_array.push(report_hash)
      #save for report jobs
      @@redis_service.set_sorted_set(REPORT_IMPORT_MSISDN,datarow[OFFER_ID]+"_"+datarow[AFFILIATE_ID]+"_"+datarow[OPERATOR_ID]+"_"+datarow[MSISDN]+"_"+datarow[DATE],DateUtility.getDateScore(datarow[DATE]))
    end
    #save batch
    (Report::StandardMsisdnDaily).collection.insert_many(report_array)
     report_array=[]
  end
end