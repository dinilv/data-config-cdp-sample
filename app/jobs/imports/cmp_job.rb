class Imports::CmpJob < ApplicationJob

    def self.perform

       begin
         #import data to last 1 hour alone
         startDate= DateUtility.getUtcStartHourFromCurrent(2)
         startHour=startDate.hour.to_s
         startDateMinusHour=startDate.strftime("%d/%m/%Y")
         endDate=Time.now.utc.strftime("%d/%m/%Y")

         link="http://api.iiris.io/cmp/config/report?start_date=<STARTDATE>&start_hour=<STARTHOUR>&end_date=<ENDDATE>&end_hour=23"
         link=link.gsub! "<STARTDATE>", startDateMinusHour
         link=link.gsub! "<STARTHOUR>", startHour
         link=link.gsub! "<ENDDATE>", endDate

         uri = URI(link)
         resp = Net::HTTP.get_response(uri)
         hash = JSON(resp.body)

         if hash
           call(hash["data"])
          else
            @@logger_import.info("No data found")
           end
       rescue => e
         puts e
         exception_job = {:action => "cmp_job", :exception => e.message , :backtrace => e.backtrace.inspect, :version=>"v1"}
         Resque.enqueue(ExceptionLogJob,exception_job)
        end
      end

    def self.custom(sdate,edate)
      begin
        link="http://api.iiris.io/cmp/config/report?start_date="+sdate+"&start_hour=0&end_date="+edate+"&end_hour=23"

        uri = URI(link)
        resp = Net::HTTP.get_response(uri)
        hash = JSON(resp.body)

        if hash
          call(hash["data"])
        else
          @@logger_import.info("No data found")
        end
      rescue => e
        puts sdate,edate,e
        exception_job = {:action => "cmp_custom_job", :exception => e.message , :backtrace => e.backtrace.inspect, :version=>"v1"}
        Resque.enqueue(ExceptionLogJob,exception_job)
      end
    end


    def self.call(data)
      begin
        @@logger_import.info("Importing Operator Data")

        data.each do |datarow|

          report_hash={}

          #create date meta data
          @@stat_service.add_date_details(datarow[MINUTE],datarow[HOUR],datarow[DATE].to_date,report_hash)

          #for sync imports in schedulers
          @@redis_service.set_sorted_set(REPORT_IMPORT_CAMPAIGNS,datarow[OFFER_ID]+"_"+datarow[DATE],
                                         DateUtility.getDateScore(datarow[DATE]))
          @@redis_service.set_sorted_set(REPORT_IMPORT_CAMPAIGN_MEDIA,datarow[OFFER_ID]+"_"+datarow[AFFILIATE_ID]+"_"+datarow[DATE],
                                         DateUtility.getDateScore(datarow[DATE]))

          #identifiers
          report_hash[MEDIA_ID]=datarow[AFFILIATE_ID]
          report_hash[CAMPAIGN_ID]=datarow[OFFER_ID]

          getOperatorStat(report_hash,datarow)

        end
      rescue => e
        puts e,data
        exception_job = {:action => "cmp_call", :exception => e.message , :backtrace => e.backtrace.inspect, :version=>"v1"}
        Resque.enqueue(ExceptionLogJob,exception_job)
      end
  end

  def self.getOperatorStat(report_hash,datarow)

    datarow[OPERATOR_REPORT_DETAILS].each do |operator_report|
      operator_stat_report=report_hash.dup

      #sync campaign operator imports
      @@redis_service.set_sorted_set(REPORT_IMPORT_CAMPAIGN_OPERATORS,datarow[OFFER_ID]+"_"+operator_report[OPERATOR_ID]+"_"+datarow[DATE],
                                     DateUtility.getDateScore(datarow[DATE]))

      #mt related
      operator_stat_report[UTC_DATE]=datarow[DATE]
      operator_stat_report[OPERATOR_ID]=operator_report[OPERATOR_ID]
      operator_stat_report[MT_SENT]=operator_report[MT_SENT]
      operator_stat_report[MT_FAIL]=operator_report[DR_FAIL]
      operator_stat_report[MT_SUCCESS]=operator_report[MT_SUCCESS]
      operator_stat_report[MT_DELIVERED]=operator_report[DR_DELIVERED]
      operator_stat_report[MT_UNKNOWN]=operator_report[DR_UNKNOWN]
      operator_stat_report[MT_RETRY]=operator_report[MT_RETRY]
      operator_stat_report[MT_SENT_BY_OPERATOR]=operator_report[MT_SENT_BY_OPERATOR]

      #subscription
      operator_stat_report[ACTIVE_SUBSCRIBERS]=operator_report[SUBSCRIPTIONS]
      operator_stat_report[UN_SUBSCRIPTIONS]=operator_report[UN_SUBSCRIPTIONS]
      operator_stat_report[SUBSCRIPTIONS]=0

      #subscription details
      operator_report[SUBSCRIPTION_DETAILS].each do |subscription|
        #subscriptions
        if subscription[DAY]==0
          operator_stat_report[SUBSCRIPTIONS]=subscription[COUNT]
        end
        operator_stat_report[SUBSCRIPTIONS_DAY+subscription[DAY].to_s]=subscription[COUNT]
      end
      #un-subscription details
      operator_report[UN_SUBSCRIPTION_DETAILS].each do |un_sub|
        operator_stat_report[UN_SUBSCRIPTIONS_DAY+un_sub[DAY].to_s]=un_sub[COUNT]
      end
      #delete old data
      Report::StandardOperatorDaily.delete_existing(report_hash[CAMPAIGN_ID],report_hash[MEDIA_ID],
                                                    operator_stat_report[OPERATOR_ID],report_hash[DATE])
      #save new data
      (Report::StandardOperatorDaily).new(operator_stat_report).save
    end

  end

end
