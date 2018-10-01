class Imports::TrackerJob < ApplicationJob

    def self.perform

       begin
         #import data to last 1 hour alone
         startDate= DateUtility.getUtcStartHourFromCurrent(2)
         startHour=startDate.hour.to_s
         startDateMinusHour=startDate.strftime("%d/%m/%Y")
         #link="http://35.194.251.197:8000/v1/report/cmp?token=1234567890&start_date=STARTDATE&start_hour=STARTHOUR"
         link="http://35.194.251.197:8088/demo/data/media"
         #link=link.gsub! "STARTDATE", startDateMinusHour
         #link=link.gsub! "STARTHOUR", startHour

         uri = URI(link)
         resp = Net::HTTP.get_response(uri)
         hash = JSON(resp.body)

         if hash
           call(hash)
          else
            @@logger_import.info("No data found")

           end
       rescue => e
         puts e
         exception_job = {:action => "tracker_job", :exception => e.message , :backtrace => e.backtrace.inspect, :version=>"v1"}
         Resque.enqueue(ExceptionLogJob,exception_job)
        end
      end

    def self.custom(sdate,edate)

      begin
        link="http://35.194.251.197:8088/demo/data/media?start_date="+sdate+"&end_date="+edate
        #link=link.gsub! "STARTDATE", startDateMinusHour
        #link=link.gsub! "STARTHOUR", startHour

        uri = URI(link)
        resp = Net::HTTP.get_response(uri)
        hash = JSON(resp.body)

        if hash
          call(hash)
        else
          @@logger_import.info("No data found")

        end
      rescue => e
        puts e
        exception_job = {:action => "tracker_custom_job", :exception => e.message , :backtrace => e.backtrace.inspect, :version=>"v1"}
        Resque.enqueue(ExceptionLogJob,exception_job)
      end
    end


    def self.call(data)

        @@logger_import.info("Importing Tracker Data")

        #for aggregation jobs
        data.each do |datarow|

          report_hash={}
          #create date meta data
          @@stat_service.add_date_details(datarow[MINUTE],datarow[HOUR],datarow[DATE].to_date,report_hash)

          #sync campaign report creation for schedulers
          @@redis_service.set_sorted_set(REPORT_IMPORT_CAMPAIGNS,datarow[OFFER_ID]+"_"+datarow[DATE])
          @@redis_service.set_sorted_set(REPORT_IMPORT_CAMPAIGN_MEDIA,datarow[OFFER_ID]+"_"+datarow[AFFILIATE_ID]+"_"+datarow[DATE])

          #identifiers
          report_hash[MEDIA_ID]=datarow[AFFILIATE_ID]
          report_hash[CAMPAIGN_ID]=datarow[OFFER_ID]
          report_hash[UTC_DATE]=datarow[DATE]
          #parse
          getMediaStat(datarow,report_hash)

          #delete old data
          Report::StandardMediaDaily.delete_existing(report_hash[CAMPAIGN_ID],report_hash[MEDIA_ID],report_hash[DATE])
          #saving new data
          (Report::StandardMediaDaily).new(report_hash).save
      end

  end

  def self.getMediaStat(datarow,report_hash)
    #media stats
    report_hash[IMPRESSIONS]=datarow[IMPRESSIONS]
    report_hash[DUPLICATE_IMPRESSIONS]=datarow[DUPLICATE_IMPRESSIONS]
    report_hash[UNIQUE_IMPRESSIONS]=datarow[UNIQUE_IMPRESSIONS]
    report_hash[INVALID_IMPRESSIONS]=datarow[INVALID_IMPRESSIONS]
    report_hash[VALID_IMPRESSIONS]= datarow[IMPRESSIONS]-datarow[INVALID_IMPRESSIONS]

    report_hash[BANNER_CLICKS]=datarow[BANNER_CLICKS]
    report_hash[DUPLICATE_BANNER_CLICKS]=datarow[DUPLICATE_BANNER_CLICKS]
    report_hash[UNIQUE_BANNER_CLICKS]=datarow[UNIQUE_BANNER_CLICKS]
    report_hash[INVALID_BANNER_CLICKS]=datarow[INVALID_BANNER_CLICKS]
    report_hash[VALID_BANNER_CLICKS]=datarow[BANNER_CLICKS]-datarow[INVALID_BANNER_CLICKS]

    report_hash[LANDING_PAGE_VIEWS]=datarow[LANDING_PAGE_VIEWS]
    report_hash[DUPLICATE_LANDING_PAGE_VIEWS]=datarow[DUPLICATE_LANDING_PAGE_VIEWS]
    report_hash[UNIQUE_LANDING_PAGE_VIEWS]=datarow[UNIQUE_LANDING_PAGE_VIEWS]
    report_hash[INVALID_LANDING_PAGE_VIEWS]=datarow[INVALID_LANDING_PAGE_VIEWS]
    report_hash[VALID_LANDING_PAGE_VIEWS]=datarow[LANDING_PAGE_VIEWS]-datarow[INVALID_LANDING_PAGE_VIEWS]

    report_hash[ENGAGMENTS]=datarow[ENGAGMENTS]
    report_hash[DUPLICATE_ENGAGMENTS]=datarow[DUPLICATE_ENGAGMENTS]
    report_hash[UNIQUE_ENGAGMENTS]=datarow[UNIQUE_ENGAGMENTS]
    report_hash[INVALID_ENGAGMENTS]=datarow[INVALID_ENGAGMENTS]
    report_hash[INVALID_ENGAGMENTS]=datarow[ENGAGMENTS]-datarow[INVALID_ENGAGMENTS]

    report_hash[SUBSCRIPTIONS]=datarow[CONVERSIONS]
    report_hash[INVALID_SUBSCRIPTIONS]=datarow[INVALID_CONVERSIONS]
    report_hash[VALID_SUBSCRIPTIONS]=datarow[CONVERSIONS]-datarow[INVALID_CONVERSIONS]

    report_hash[CONTENT_VIEWS]=datarow[CONTENT_VIEWS]
    report_hash[MEDIA_POSTBACKS]=datarow[SENT_CONVERSIONS]
    report_hash[SUBSCRIPTION_POSTBACKS]=datarow[SENT_CONVERSIONS]

  end

end
