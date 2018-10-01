class Analytics::StatService < ApplicationService

  def add_date_details(minute,hour,date,report_hash)
    report_hash[DATE]= Time.utc(date.year, date.month, date.day,hour,minute,0)
  end

  def graph_stats_formatted(date,report_hash)
    report_hash[WEEK_OF_YEAR] = report_hash[DATE].strftime("%U").to_i
    report_hash[MONTH] = report_hash[DATE].strftime("%b")
    report_hash[MONTH_ID] =  report_hash[DATE].strftime("%m").to_i
    report_hash[YEAR] =  report_hash[DATE].strftime("%Y").to_i
    report_hash[DAY_OF_YEAR] = report_hash[YEAR]+report_hash[DATE].strftime("%j").to_i
    report_hash[GRAPH_ID]=  report_hash[DATE].day.to_s + " " + report_hash[MONTH]
  end

  def media_stats_formatted(media_data,report_hash)
    report_hash[IMPRESSIONS]=Number.new(media_data[IMPRESSIONS])
    report_hash[UNIQUE_IMPRESSIONS]=Number.new(media_data[UNIQUE_IMPRESSIONS])
    report_hash[VALID_IMPRESSIONS]=Number.new(media_data[VALID_IMPRESSIONS])
    report_hash[INVALID_IMPRESSIONS]=Number.new(media_data[INVALID_IMPRESSIONS])
    report_hash[DUPLICATE_IMPRESSIONS]=Number.new(media_data[DUPLICATE_IMPRESSIONS])

    report_hash[BANNER_CLICKS]=Number.new(media_data[BANNER_CLICKS])
    report_hash[UNIQUE_BANNER_CLICKS]=Number.new(media_data[UNIQUE_BANNER_CLICKS])
    report_hash[VALID_BANNER_CLICKS]=Number.new(media_data[VALID_BANNER_CLICKS])
    report_hash[INVALID_BANNER_CLICKS]=Number.new(media_data[INVALID_BANNER_CLICKS])
    report_hash[DUPLICATE_BANNER_CLICKS]=Number.new(media_data[DUPLICATE_BANNER_CLICKS])

    report_hash[LANDING_PAGE_VIEWS]=Number.new(media_data[LANDING_PAGE_VIEWS])
    report_hash[UNIQUE_LANDING_PAGE_VIEWS]=Number.new(media_data[UNIQUE_LANDING_PAGE_VIEWS])
    report_hash[VALID_LANDING_PAGE_VIEWS]=Number.new(media_data[VALID_LANDING_PAGE_VIEWS])
    report_hash[INVALID_LANDING_PAGE_VIEWS]=Number.new(media_data[INVALID_LANDING_PAGE_VIEWS])
    report_hash[DUPLICATE_LANDING_PAGE_VIEWS]=Number.new(media_data[DUPLICATE_LANDING_PAGE_VIEWS])

    report_hash[ENGAGMENTS]=Number.new(media_data[ENGAGMENTS])
    report_hash[UNIQUE_ENGAGMENTS]=Number.new(media_data[UNIQUE_ENGAGMENTS])
    report_hash[INVALID_ENGAGMENTS]=Number.new(media_data[INVALID_ENGAGMENTS])
    report_hash[VALID_ENGAGMENTS]=Number.new(media_data[VALID_ENGAGMENTS])
    report_hash[DUPLICATE_ENGAGMENTS]=Number.new(media_data[DUPLICATE_ENGAGMENTS])

    report_hash[SUBSCRIPTIONS]=Number.new(media_data[SUBSCRIPTIONS])
    report_hash[VALID_SUBSCRIPTIONS]=Number.new(media_data[VALID_SUBSCRIPTIONS])
    report_hash[INVALID_SUBSCRIPTIONS]=Number.new(media_data[INVALID_SUBSCRIPTIONS])

    report_hash[CONTENT_VIEWS]=Number.new(media_data[CONTENT_VIEWS])
    report_hash[MEDIA_POSTBACKS]=Number.new(media_data[MEDIA_POSTBACKS])
    report_hash[SUBSCRIPTION_POSTBACKS]=Number.new(media_data[SUBSCRIPTION_POSTBACKS])
  end


  def operator_stats_formatted(operator_data,report_hash)
    report_hash[MT_SENT]=Number.new(operator_data[MT_SENT])
    report_hash[MT_SENT_BY_OPERATOR]=Number.new(operator_data[MT_SENT_BY_OPERATOR])
    report_hash[MT_FAIL]=Number.new(operator_data[MT_FAIL])
    report_hash[MT_SUCCESS]=Number.new(operator_data[MT_SUCCESS])
    report_hash[MT_DELIVERED]=Number.new(operator_data[MT_DELIVERED])
    report_hash[MT_UNKNOWN]=Number.new(operator_data[MT_UNKNOWN])
    report_hash[MT_RETRY]=Number.new(operator_data[MT_RETRY])

    #subscriptions
    report_hash[SUBSCRIBERS]=Number.new(operator_data[SUBSCRIBERS])
    report_hash[ACTIVE_SUBSCRIBERS]=Number.new(operator_data[ACTIVE_SUBSCRIBERS])
    report_hash[UN_SUBSCRIPTIONS]=Number.new(operator_data[UN_SUBSCRIPTIONS])

    #un-subscriptions
    report_hash[UN_SUBSCRIPTIONS_DAY_0]=Number.new(operator_data[UN_SUBSCRIPTIONS_DAY_0])
    report_hash[UN_SUBSCRIPTIONS_DAY_1]=Number.new(operator_data[UN_SUBSCRIPTIONS_DAY_1])
    report_hash[UN_SUBSCRIPTIONS_DAY_3]=Number.new(operator_data[UN_SUBSCRIPTIONS_DAY_3])
    report_hash[UN_SUBSCRIPTIONS_DAY_7]=Number.new(operator_data[UN_SUBSCRIPTIONS_DAY_7])
    report_hash[UN_SUBSCRIPTIONS_DAY_15]=Number.new(operator_data[UN_SUBSCRIPTIONS_DAY_15])

    #subscriptions
    report_hash[SUBSCRIPTIONS_DAY_0]=Number.new(operator_data[SUBSCRIPTIONS_DAY_0])
    report_hash[SUBSCRIPTIONS_DAY_1]=Number.new(operator_data[SUBSCRIPTIONS_DAY_1])
    report_hash[SUBSCRIPTIONS_DAY_3]=Number.new(operator_data[SUBSCRIPTIONS_DAY_3])
    report_hash[SUBSCRIPTIONS_DAY_7]=Number.new(operator_data[SUBSCRIPTIONS_DAY_7])
    report_hash[SUBSCRIPTIONS_DAY_15]=Number.new(operator_data[SUBSCRIPTIONS_DAY_15])
  end

  def msisdn_stats(msisdn_data,report_hash)
    report_hash[MT_SENT]=Number.new(msisdn_data[MT_SENT])
    report_hash[MT_SENT_BY_OPERATOR]=Number.new(msisdn_data[MT_SENT_BY_OPERATOR])
    report_hash[MT_FAIL]=Number.new(msisdn_data[MT_FAIL])
    report_hash[MT_SUCCESS]=Number.new(msisdn_data[MT_SUCCESS])
    report_hash[MT_DELIVERED]=Number.new(msisdn_data[MT_DELIVERED])
    report_hash[MT_UNKNOWN]=Number.new(msisdn_data[MT_UNKNOWN])
    report_hash[MT_RETRY]=Number.new(msisdn_data[MT_RETRY])

    #subscriptions
    report_hash[SUBSCRIPTIONS]=Number.new(msisdn_data[SUBSCRIPTIONS])
    report_hash[UN_SUBSCRIPTIONS]=Number.new(msisdn_data[UN_SUBSCRIPTIONS])

  end

    def calculate_media_finance_stats_converted(report_hash)
    #dollar converted
    report_hash[MEDIA_COST_LOCAL]=Amount.new(report_hash[CURRENCY],
                                             ((report_hash[VALID_SUBSCRIPTIONS].to_f * report_hash[MEDIA_PAYOUT_DOLLAR].to_f * report_hash[EXCHANGE].to_f).round(2)))
  end

  def calculate_media_finance_stats_dollar(report_hash)
    report_hash[MEDIA_COST_DOLLAR]=Dollar.new((report_hash[VALID_SUBSCRIPTIONS].to_f * report_hash[MEDIA_PAYOUT_DOLLAR].to_f ).round(2))
 end

  def calculate_operator_finance_stats_converted(report_hash)
    #dollar converted
   report_hash[NET_REVENUE_LOCAL]= Amount.new(report_hash[CURRENCY],
                                               (report_hash[MT_DELIVERED].to_f * report_hash[NET_CHARGE_DOLLAR].to_f * report_hash[EXCHANGE].to_f).round(2))
    report_hash[REVENUE_LOCAL]= Amount.new(report_hash[CURRENCY],
                                           (report_hash[MT_DELIVERED].to_f * report_hash[UNIT_CHARGE_DOLLAR].to_f * report_hash[EXCHANGE].to_f).round(2))
  end
  def calculate_operator_finance_stats_dollar(report_hash)
    #dollar converted
    report_hash[NET_REVENUE_DOLLAR]= Dollar.new(
                                               (report_hash[MT_DELIVERED].to_f * report_hash[NET_CHARGE_DOLLAR].to_f ).round(2))
    report_hash[REVENUE_DOLLAR]= Dollar.new(
                                           (report_hash[MT_DELIVERED].to_f * report_hash[UNIT_CHARGE_DOLLAR].to_f ).round(2))
  end

  def calculate_msisdn_finance_stats(report_hash)
    #dollar converted
    report_hash[MEDIA_COST_LOCAL]=Amount.new(report_hash[CURRENCY],
                                             ((report_hash[SUBSCRIPTIONS].to_f * report_hash[MEDIA_PAYOUT_DOLLAR].to_f * report_hash[EXCHANGE].to_f).round(2)))
    report_hash[MEDIA_COST_DOLLAR]=Dollar.new((report_hash[SUBSCRIPTIONS].to_f * report_hash[MEDIA_PAYOUT_DOLLAR].to_f ).round(2))

  end

  def deduced_media_stats_dollar(report_hash)
    #from operator stats
    if report_hash[SUBSCRIBERS].to_i > 0
      report_hash[AVERAGE_REVENUE_PER_SUBSCRIBER_DOLLAR]=Dollar.new(((report_hash[REVENUE_DOLLAR].to_f/report_hash[SUBSCRIBERS].to_f)).round(2))
      report_hash[COST_PER_ACTIVE_SUBSCRIBER_DOLLAR]=Dollar.new(((report_hash[MEDIA_COST_DOLLAR].to_f/report_hash[SUBSCRIBERS].to_f)).round(2))
    end
  end
  def deduced_media_stats_converted(report_hash)
    #from operator stats
    if report_hash[SUBSCRIBERS].to_i > 0
      report_hash[AVERAGE_REVENUE_PER_SUBSCRIBER_LOCAL]=Amount.new(report_hash[CURRENCY],
                                                                   ((report_hash[REVENUE_LOCAL].to_f/report_hash[SUBSCRIBERS].to_f)).round(2))
      report_hash[COST_PER_ACTIVE_SUBSCRIBER_LOCAL]=Amount.new(report_hash[CURRENCY],
                                                               ((report_hash[MEDIA_COST_LOCAL].to_f/report_hash[SUBSCRIBERS].to_f)).round(2))
    end
  end

  def deduced_msisdn_finance(report_hash)

    puts report_hash[SUBSCRIPTIONS]
    if report_hash[SUBSCRIPTIONS].to_i > 0

      report_hash[COST_PER_ACTIVE_SUBSCRIBER_LOCAL]=Amount.new(report_hash[CURRENCY],
                                                               ((report_hash[MEDIA_COST_LOCAL].to_f/report_hash[SUBSCRIPTIONS].to_f)).round(2))
      report_hash[COST_PER_ACTIVE_SUBSCRIBER_DOLLAR]=Dollar.new(((report_hash[MEDIA_COST_DOLLAR].to_f/report_hash[SUBSCRIPTIONS].to_f)).round(2))

    end
  end

  def deduced_media_percentages(report_hash)

    if report_hash[SUBSCRIPTIONS].to_i >0
      report_hash[VALID_SUB_PERCENT]=Percentage.new(((report_hash[VALID_SUBSCRIPTIONS].to_f/report_hash[SUBSCRIPTIONS].to_f)*100).round(2))
      report_hash[SUB_RATE_PERCENT]=Percentage.new((report_hash[SUBSCRIPTIONS].to_f/(report_hash[ENGAGMENTS].to_f )*100).round(2))
    end

    if report_hash[ENGAGMENTS].to_i > 0
      report_hash[VALID_ENGAGMENT_PERCENT]=Percentage.new((((report_hash[ENGAGMENTS].to_f-report_hash[INVALID_ENGAGMENTS].to_f)/report_hash[ENGAGMENTS].to_f)*100).round(2))
    end

    if report_hash[BANNER_CLICKS].to_i > 0
      report_hash[VALID_CLICK_PERCENT]=Percentage.new((((report_hash[BANNER_CLICKS].to_f-report_hash[INVALID_BANNER_CLICKS].to_f)/report_hash[BANNER_CLICKS].to_f) * 100).round(2))
      report_hash[LANDING_PAGE_VALID_PERCENT]=Percentage.new((((report_hash[LANDING_PAGE_VIEWS].to_f-report_hash[INVALID_LANDING_PAGE_VIEWS].to_f)/report_hash[LANDING_PAGE_VIEWS].to_f)*100).round(2))
    end

  end


  def deduced_operator_percentages(report_hash)

    if report_hash[SUBSCRIPTIONS].to_i >0 && report_hash[UN_SUBSCRIPTIONS_DAY_0].to_i >0
      report_hash[NEW_SUB_UNSUB_PERCENT]=Percentage.new(((report_hash[UN_SUBSCRIPTIONS_DAY_0].to_f/report_hash[SUBSCRIPTIONS].to_f)*100).round(2))
      report_hash[UNSUB_PERCENT]=Percentage.new(((report_hash[UN_SUBSCRIPTIONS].to_f/(report_hash[SUBSCRIPTIONS_DAY_1].to_f + report_hash[SUBSCRIPTIONS].to_f))*100).round(2))
    end

    if report_hash[MT_SENT].to_i > 0
      report_hash[MT_SUCCESS_PERCENT]=Percentage.new(((report_hash[MT_SUCCESS].to_f/report_hash[MT_SENT].to_f)*100).round(2))
      report_hash[MT_SENT_PERCENT]=Percentage.new(((report_hash[MT_SENT_BY_OPERATOR].to_f/report_hash[MT_SENT].to_f)*100).round(2))
    end

    if report_hash[MT_DELIVERED].to_i > 0
      report_hash[CONTENT_VIEW_PERCENT]=Percentage.new(((report_hash[CONTENT_VIEWS].to_f/report_hash[MT_DELIVERED].to_f)*100).round(2))
    end

  end

  def deduced_msisdn_percentages(report_hash)

    if report_hash[MT_SENT].to_i > 0
      report_hash[MT_SUCCESS_PERCENT]=Percentage.new(((report_hash[MT_SUCCESS].to_f/report_hash[MT_SENT].to_f)*100).round(2))
      report_hash[MT_SENT_PERCENT]=Percentage.new(((report_hash[MT_SENT_BY_OPERATOR].to_f/report_hash[MT_SENT].to_f)*100).round(2))
    end

    if report_hash[MT_DELIVERED].to_i > 0
      report_hash[CONTENT_VIEW_PERCENT]=Percentage.new(((report_hash[CONTENT_VIEWS].to_f/report_hash[MT_DELIVERED].to_f)*100).round(2))
    end

  end

  def lifetime_msisdn_stats(current_data,lifetime_data,report_hash)

    #media stats
    report_hash[IMPRESSIONS]=Number.new(lifetime_data[IMPRESSIONS][VALUE_SHORT].to_i + current_data[IMPRESSIONS][VALUE_SHORT].to_i)
    report_hash[BANNER_CLICKS]=Number.new(lifetime_data[BANNER_CLICKS][VALUE_SHORT].to_i + current_data[BANNER_CLICKS][VALUE_SHORT].to_i)
    report_hash[LANDING_PAGE_VIEWS]=Number.new(lifetime_data[LANDING_PAGE_VIEWS][VALUE_SHORT].to_i + current_data[LANDING_PAGE_VIEWS][VALUE_SHORT].to_i)
    report_hash[ENGAGMENTS]=Number.new(lifetime_data[ENGAGMENTS][VALUE_SHORT].to_i + current_data[ENGAGMENTS][VALUE_SHORT].to_i)
    report_hash[SUBSCRIPTIONS]=Number.new(lifetime_data[SUBSCRIPTIONS][VALUE_SHORT].to_i + current_data[SUBSCRIPTIONS][VALUE_SHORT].to_i)
    report_hash[CONTENT_VIEWS]=Number.new(lifetime_data[CONTENT_VIEWS][VALUE_SHORT].to_i + current_data[CONTENT_VIEWS][VALUE_SHORT].to_i)

    #operator stats
    report_hash[MT_SENT]=Number.new(lifetime_data[MT_SENT][VALUE_SHORT].to_i + current_data[MT_SENT][VALUE_SHORT].to_i)
    report_hash[MT_SENT_BY_OPERATOR]=Number.new(lifetime_data[MT_SENT_BY_OPERATOR][VALUE_SHORT].to_i + current_data[MT_SENT_BY_OPERATOR][VALUE_SHORT].to_i)
    report_hash[MT_FAIL]=Number.new(lifetime_data[MT_FAIL][VALUE_SHORT].to_i + current_data[MT_FAIL][VALUE_SHORT].to_i)
    report_hash[MT_SUCCESS]=Number.new(lifetime_data[MT_SUCCESS][VALUE_SHORT].to_i + current_data[MT_SUCCESS][VALUE_SHORT].to_i)
    report_hash[MT_DELIVERED]=Number.new(lifetime_data[MT_DELIVERED][VALUE_SHORT].to_i + current_data[MT_DELIVERED][VALUE_SHORT].to_i)
    report_hash[MT_UNKNOWN]=Number.new(lifetime_data[MT_UNKNOWN][VALUE_SHORT].to_i + current_data[MT_UNKNOWN][VALUE_SHORT].to_i)
    report_hash[MT_RETRY]=Number.new(lifetime_data[MT_RETRY][VALUE_SHORT].to_i + current_data[MT_RETRY][VALUE_SHORT].to_i)
    report_hash[UN_SUBSCRIPTIONS]=Number.new(lifetime_data[UN_SUBSCRIPTIONS][VALUE_SHORT].to_i + current_data[UN_SUBSCRIPTIONS][VALUE_SHORT].to_i)

    #finance stats
    report_hash[NET_REVENUE_DOLLAR]=Dollar.new((lifetime_data[NET_REVENUE_DOLLAR][VALUE_SHORT].to_f + current_data[NET_REVENUE_DOLLAR][VALUE_SHORT].to_f).round(2))
    report_hash[REVENUE_DOLLAR]=Dollar.new((lifetime_data[REVENUE_DOLLAR][VALUE_SHORT].to_f + current_data[REVENUE_DOLLAR][VALUE_SHORT].to_f).round(2))
    report_hash[NET_REVENUE_LOCAL]=Amount.new(report_hash[CURRENCY],(lifetime_data[NET_REVENUE_LOCAL][VALUE_SHORT].to_f + current_data[NET_REVENUE_LOCAL][VALUE_SHORT].to_f).round(2))
    report_hash[REVENUE_LOCAL]=Amount.new(report_hash[CURRENCY],(lifetime_data[REVENUE_LOCAL][VALUE_SHORT].to_f + current_data[REVENUE_LOCAL][VALUE_SHORT].to_f).round(2))

  end
  def lifetime_media_stats(current_data,lifetime_data,report_hash)

    report_hash[IMPRESSIONS]=Number.new(lifetime_data[IMPRESSIONS][VALUE_SHORT].to_i + current_data[IMPRESSIONS][VALUE_SHORT].to_i)
    report_hash[UNIQUE_IMPRESSIONS]=Number.new(lifetime_data[UNIQUE_IMPRESSIONS][VALUE_SHORT].to_i + current_data[UNIQUE_IMPRESSIONS][VALUE_SHORT].to_i)
    report_hash[INVALID_IMPRESSIONS]=Number.new(lifetime_data[INVALID_IMPRESSIONS][VALUE_SHORT].to_i + current_data[INVALID_IMPRESSIONS][VALUE_SHORT].to_i)
    report_hash[VALID_IMPRESSIONS]=Number.new(lifetime_data[VALID_IMPRESSIONS][VALUE_SHORT].to_i + current_data[VALID_IMPRESSIONS][VALUE_SHORT].to_i)
    report_hash[DUPLICATE_IMPRESSIONS]=Number.new(lifetime_data[DUPLICATE_IMPRESSIONS][VALUE_SHORT].to_i + current_data[DUPLICATE_IMPRESSIONS][VALUE_SHORT].to_i)

    report_hash[BANNER_CLICKS]=Number.new(lifetime_data[BANNER_CLICKS][VALUE_SHORT].to_i + current_data[BANNER_CLICKS][VALUE_SHORT].to_i)
    report_hash[UNIQUE_BANNER_CLICKS]=Number.new(lifetime_data[UNIQUE_BANNER_CLICKS][VALUE_SHORT].to_i + current_data[UNIQUE_BANNER_CLICKS[VALUE_SHORT]].to_i)
    report_hash[INVALID_BANNER_CLICKS]=Number.new(lifetime_data[INVALID_BANNER_CLICKS][VALUE_SHORT].to_i + current_data[INVALID_BANNER_CLICKS][VALUE_SHORT].to_i)
    report_hash[VALID_BANNER_CLICKS]=Number.new(lifetime_data[VALID_BANNER_CLICKS][VALUE_SHORT].to_i + current_data[VALID_BANNER_CLICKS][VALUE_SHORT].to_i)
    report_hash[DUPLICATE_BANNER_CLICKS]=Number.new(lifetime_data[DUPLICATE_BANNER_CLICKS][VALUE_SHORT].to_i + current_data[DUPLICATE_BANNER_CLICKS][VALUE_SHORT].to_i)

    report_hash[LANDING_PAGE_VIEWS]=Number.new(lifetime_data[LANDING_PAGE_VIEWS][VALUE_SHORT].to_i + current_data[LANDING_PAGE_VIEWS][VALUE_SHORT].to_i)
    report_hash[UNIQUE_LANDING_PAGE_VIEWS]=Number.new(lifetime_data[UNIQUE_LANDING_PAGE_VIEWS][VALUE_SHORT].to_i + current_data[UNIQUE_LANDING_PAGE_VIEWS][VALUE_SHORT].to_i)
    report_hash[INVALID_LANDING_PAGE_VIEWS]=Number.new(lifetime_data[INVALID_LANDING_PAGE_VIEWS][VALUE_SHORT].to_i + current_data[INVALID_LANDING_PAGE_VIEWS][VALUE_SHORT].to_i)
    report_hash[VALID_LANDING_PAGE_VIEWS]=Number.new(lifetime_data[VALID_LANDING_PAGE_VIEWS][VALUE_SHORT].to_i + current_data[VALID_LANDING_PAGE_VIEWS][VALUE_SHORT].to_i)
    report_hash[DUPLICATE_LANDING_PAGE_VIEWS]=Number.new(lifetime_data[DUPLICATE_LANDING_PAGE_VIEWS][VALUE_SHORT].to_i + current_data[DUPLICATE_LANDING_PAGE_VIEWS][VALUE_SHORT].to_i)

    report_hash[ENGAGMENTS]=Number.new(lifetime_data[ENGAGMENTS][VALUE_SHORT].to_i + current_data[ENGAGMENTS][VALUE_SHORT].to_i)
    report_hash[UNIQUE_ENGAGMENTS]=Number.new(lifetime_data[UNIQUE_ENGAGMENTS][VALUE_SHORT].to_i +  -current_data[UNIQUE_ENGAGMENTS][VALUE_SHORT].to_i)
    report_hash[INVALID_ENGAGMENTS]=Number.new(lifetime_data[INVALID_ENGAGMENTS][VALUE_SHORT].to_i + current_data[INVALID_ENGAGMENTS][VALUE_SHORT].to_i)
    report_hash[VALID_ENGAGMENTS]=Number.new(lifetime_data[VALID_ENGAGMENTS][VALUE_SHORT].to_i + current_data[VALID_ENGAGMENTS][VALUE_SHORT].to_i)
    report_hash[DUPLICATE_ENGAGMENTS]=Number.new(lifetime_data[DUPLICATE_ENGAGMENTS][VALUE_SHORT].to_i + current_data[DUPLICATE_ENGAGMENTS][VALUE_SHORT].to_i)

    report_hash[SUBSCRIPTIONS]=Number.new(lifetime_data[SUBSCRIPTIONS][VALUE_SHORT].to_i + current_data[SUBSCRIPTIONS][VALUE_SHORT].to_i)
    report_hash[VALID_SUBSCRIPTIONS]=Number.new(lifetime_data[VALID_SUBSCRIPTIONS][VALUE_SHORT].to_i +  -current_data[VALID_SUBSCRIPTIONS][VALUE_SHORT].to_i)
    report_hash[INVALID_SUBSCRIPTIONS]=Number.new(lifetime_data[INVALID_SUBSCRIPTIONS][VALUE_SHORT].to_i + current_data[INVALID_SUBSCRIPTIONS][VALUE_SHORT].to_i)
    report_hash[CONTENT_VIEWS]=Number.new(lifetime_data[CONTENT_VIEWS][VALUE_SHORT].to_i + current_data[CONTENT_VIEWS][VALUE_SHORT].to_i)

  end

  def lifetime_operator_stats(current_data,lifetime_data,report_hash)

    report_hash[MT_SENT]=Number.new(lifetime_data[MT_SENT][VALUE_SHORT].to_i + current_data[MT_SENT][VALUE_SHORT].to_i)
    report_hash[MT_SENT_BY_OPERATOR]=Number.new(lifetime_data[MT_SENT_BY_OPERATOR][VALUE_SHORT].to_i + current_data[MT_SENT_BY_OPERATOR][VALUE_SHORT].to_i)
    report_hash[MT_FAIL]=Number.new(lifetime_data[MT_FAIL][VALUE_SHORT].to_i + current_data[MT_FAIL][VALUE_SHORT].to_i)
    report_hash[MT_SUCCESS]=Number.new(lifetime_data[MT_SUCCESS][VALUE_SHORT].to_i + current_data[MT_SUCCESS][VALUE_SHORT].to_i)
    report_hash[MT_DELIVERED]=Number.new(lifetime_data[MT_DELIVERED][VALUE_SHORT].to_i + current_data[MT_DELIVERED][VALUE_SHORT].to_i)
    report_hash[MT_UNKNOWN]=Number.new(lifetime_data[MT_UNKNOWN][VALUE_SHORT].to_i + current_data[MT_UNKNOWN][VALUE_SHORT].to_i)
    report_hash[MT_RETRY]=Number.new(lifetime_data[MT_RETRY][VALUE_SHORT].to_i + current_data[MT_RETRY][VALUE_SHORT].to_i)
    report_hash[SUBSCRIBERS]=Number.new(lifetime_data[SUBSCRIBERS][VALUE_SHORT].to_i+ current_data[ACTIVE_SUBSCRIBERS][VALUE_SHORT].to_i)
    report_hash[ACTIVE_SUBSCRIBERS]=Number.new(current_data[ACTIVE_SUBSCRIBERS][VALUE_SHORT].to_i)
    report_hash[UN_SUBSCRIPTIONS]=Number.new(lifetime_data[UN_SUBSCRIPTIONS][VALUE_SHORT].to_i + current_data[UN_SUBSCRIPTIONS][VALUE_SHORT].to_i)
    #un-subscriptions
    report_hash[UN_SUBSCRIPTIONS_DAY_0]=Number.new(lifetime_data[UN_SUBSCRIPTIONS_DAY_0][VALUE_SHORT].to_i + current_data[UN_SUBSCRIPTIONS_DAY_0][VALUE_SHORT].to_i)
    report_hash[UN_SUBSCRIPTIONS_DAY_1]=Number.new(lifetime_data[UN_SUBSCRIPTIONS_DAY_1][VALUE_SHORT].to_i + current_data[UN_SUBSCRIPTIONS_DAY_1][VALUE_SHORT].to_i)
    report_hash[UN_SUBSCRIPTIONS_DAY_3]=Number.new(lifetime_data[UN_SUBSCRIPTIONS_DAY_3][VALUE_SHORT].to_i + current_data[UN_SUBSCRIPTIONS_DAY_3][VALUE_SHORT].to_i)
    report_hash[UN_SUBSCRIPTIONS_DAY_7]=Number.new(lifetime_data[UN_SUBSCRIPTIONS_DAY_7][VALUE_SHORT].to_i + current_data[UN_SUBSCRIPTIONS_DAY_7][VALUE_SHORT].to_i)
    report_hash[UN_SUBSCRIPTIONS_DAY_15]=Number.new(lifetime_data[UN_SUBSCRIPTIONS_DAY_15][VALUE_SHORT].to_i + current_data[UN_SUBSCRIPTIONS_DAY_15][VALUE_SHORT].to_i)
    #subscriptions
    report_hash[SUBSCRIPTIONS_DAY_0]=Number.new(lifetime_data[SUBSCRIPTIONS_DAY_0][VALUE_SHORT].to_i + current_data[SUBSCRIPTIONS_DAY_0][VALUE_SHORT].to_i)
    report_hash[SUBSCRIPTIONS_DAY_1]=Number.new(lifetime_data[SUBSCRIPTIONS_DAY_1][VALUE_SHORT].to_i + current_data[SUBSCRIPTIONS_DAY_1][VALUE_SHORT].to_i)
    report_hash[SUBSCRIPTIONS_DAY_3]=Number.new(lifetime_data[SUBSCRIPTIONS_DAY_3][VALUE_SHORT].to_i + current_data[SUBSCRIPTIONS_DAY_3][VALUE_SHORT].to_i)
    report_hash[SUBSCRIPTIONS_DAY_7]=Number.new(lifetime_data[SUBSCRIPTIONS_DAY_7][VALUE_SHORT].to_i + current_data[SUBSCRIPTIONS_DAY_7][VALUE_SHORT].to_i)
    report_hash[SUBSCRIPTIONS_DAY_15]=Number.new(lifetime_data[SUBSCRIPTIONS_DAY_15][VALUE_SHORT].to_i + current_data[SUBSCRIPTIONS_DAY_15][VALUE_SHORT].to_i)
  end

  def lifetime_media_finance_stats(current_data,lifetime_data,report_hash)
    report_hash[MEDIA_COST_LOCAL]=Amount.new(report_hash[CURRENCY],(lifetime_data[MEDIA_COST_LOCAL][VALUE_SHORT].to_f + current_data[MEDIA_COST_LOCAL][VALUE_SHORT].to_f))
    report_hash[MEDIA_COST_DOLLAR]=Dollar.new((lifetime_data[MEDIA_COST_DOLLAR][VALUE_SHORT].to_f + current_data[MEDIA_COST_DOLLAR][VALUE_SHORT].to_f))
 end

  def lifetime_operator_finance_stats(current_data,lifetime_data,report_hash)
    report_hash[NET_REVENUE_LOCAL]= Amount.new(report_hash[CURRENCY],(lifetime_data[NET_REVENUE_LOCAL][VALUE_SHORT].to_f + current_data[NET_REVENUE_LOCAL][VALUE_SHORT].to_f))
    report_hash[REVENUE_LOCAL]= Amount.new(report_hash[CURRENCY],(lifetime_data[REVENUE_LOCAL][VALUE_SHORT].to_f + current_data[REVENUE_LOCAL][VALUE_SHORT].to_f))
    report_hash[NET_REVENUE_DOLLAR]= Dollar.new((lifetime_data[NET_REVENUE_DOLLAR][VALUE_SHORT].to_f + current_data[NET_REVENUE_DOLLAR][VALUE_SHORT].to_f))
    report_hash[REVENUE_DOLLAR]= Dollar.new((lifetime_data[REVENUE_DOLLAR][VALUE_SHORT].to_f + current_data[REVENUE_DOLLAR][VALUE_SHORT].to_f))
  end

  def parse_media_finance_stats(input_data,report_hash)
    report_hash[MEDIA_COST_LOCAL]=Amount.new(report_hash[CURRENCY],input_data[MEDIA_COST_LOCAL].to_f)
    report_hash[MEDIA_COST_DOLLAR]=Dollar.new(input_data[MEDIA_COST_DOLLAR].to_f)
  end
  def parse_operator_finance_stats(input_data,report_hash)
    report_hash[NET_REVENUE_LOCAL]= Amount.new(report_hash[CURRENCY],input_data[NET_REVENUE_LOCAL].to_f)
    report_hash[REVENUE_LOCAL]= Amount.new(report_hash[CURRENCY],input_data[REVENUE_LOCAL].to_f)
    report_hash[NET_REVENUE_DOLLAR]= Dollar.new(input_data[NET_REVENUE_DOLLAR].to_f)
    report_hash[REVENUE_DOLLAR]= Dollar.new(input_data[REVENUE_DOLLAR].to_f)
  end


  def add_campaign_thirty_subscribers(report_hash)
    previous_day=DateUtility.getUtcStartDateFromDateAndDays(report_hash[DATE],31)
    existing_data=Campaign::SummaryThirty.find_sub_by_cid_and_date(report_hash[COMPANY_ID],report_hash[CAMPAIGN_ID],previous_day)
    if existing_data.length >0
      report_hash[SUBSCRIBERS] = Number.new(existing_data[0][SUBSCRIBERS_SHORT][VALUE_SHORT].to_i+report_hash[ACTIVE_SUBSCRIBERS].to_i)
    else
      report_hash[SUBSCRIBERS]=Number.new(0+report_hash[ACTIVE_SUBSCRIBERS].to_i)
    end
  end

  def add_campaign_media_subscribers(report_hash)
    previous_day=DateUtility.getUtcStartDateFromDateAndDays(report_hash[DATE],1)
    existing_data=Campaign::MediaDaily.find_sub_by_cid_and_media_and_date(report_hash[COMPANY_ID],report_hash[CAMPAIGN_ID],report_hash[MEDIA_ID],
                                                                          previous_day)

    if existing_data.length >0
      report_hash[SUBSCRIBERS] = Number.new(existing_data[0][SUBSCRIBERS_SHORT][VALUE_SHORT].to_i+report_hash[ACTIVE_SUBSCRIBERS].to_i)
    else
      report_hash[SUBSCRIBERS]=Number.new(0+report_hash[ACTIVE_SUBSCRIBERS].to_i)
    end
  end

  def add_campaign_operator_subscribers(report_hash)
    previous_day=DateUtility.getUtcStartDateFromDateAndDays(report_hash[DATE],1)
    existing_data=Campaign::OperatorDaily.find_sub_by_cid_and_op_and_date(report_hash[COMPANY_ID],report_hash[CAMPAIGN_ID],report_hash[OPERATOR_ID],
                                                                          previous_day)

    if existing_data.length >0
      report_hash[SUBSCRIBERS] = Number.new(existing_data[0][SUBSCRIBERS_SHORT][VALUE_SHORT].to_i+report_hash[ACTIVE_SUBSCRIBERS].to_i)
    else
      report_hash[SUBSCRIBERS]=Number.new(0+report_hash[ACTIVE_SUBSCRIBERS].to_i)
    end
  end

  def add_account_subscribers(report_hash)
    previous_day=DateUtility.getUtcStartDateFromDateAndDays(report_hash[DATE],1)
    existing_data= Account::SummaryDaily.find_sub_by_cp_and_date(report_hash[COMPANY_ID],previous_day)
    if existing_data.length >0
      report_hash[SUBSCRIBERS] = Number.new(existing_data[0][SUBSCRIBERS_SHORT][VALUE_SHORT].to_i+report_hash[ACTIVE_SUBSCRIBERS].to_i)
    else
      report_hash[SUBSCRIBERS]=Number.new(0+report_hash[ACTIVE_SUBSCRIBERS].to_i)
    end
  end

  def add_account_media_subscribers(report_hash)
    previous_day=DateUtility.getUtcStartDateFromDateAndDays(report_hash[DATE],1)
    existing_data=Account::MediaDaily.find_sub_by_cp_and_media_and_date(report_hash[COMPANY_ID],report_hash[MEDIA_ID],
                                                                    previous_day)
    if existing_data.length >0
      report_hash[SUBSCRIBERS] = Number.new(existing_data[0][SUBSCRIBERS_SHORT][VALUE_SHORT].to_i+report_hash[ACTIVE_SUBSCRIBERS].to_i)
    else
      report_hash[SUBSCRIBERS]=Number.new(0+report_hash[ACTIVE_SUBSCRIBERS].to_i)
    end
  end

  def add_account_operator_subscribers(report_hash)
    previous_day=DateUtility.getUtcStartDateFromDateAndDays(report_hash[DATE],1)
    existing_data=Account::OperatorDaily.find_sub_by_cp_and_op_and_date(report_hash[COMPANY_ID],report_hash[OPERATOR_ID],
                                                                        previous_day)
    if existing_data.length >0
      report_hash[SUBSCRIBERS] = Number.new(existing_data[0][SUBSCRIBERS_SHORT][VALUE_SHORT].to_i+report_hash[ACTIVE_SUBSCRIBERS].to_i)
    else
      report_hash[SUBSCRIBERS]=Number.new(0+report_hash[ACTIVE_SUBSCRIBERS].to_i)
    end
  end

  def add_account_counts(report_hash)
    report_hash[LIVE_OPERATOR_COUNT]=Campaign.account_active_operator_count(report_hash[COMPANY_ID].to_i)
    report_hash[LIVE_MEDIA_COUNT]=Campaign.account_active_media_count(report_hash[COMPANY_ID].to_i)
    report_hash[LIVE_CAMPAIGN_COUNT]=Campaign.account_active_count(report_hash[COMPANY_ID].to_i)
    report_hash[LIVE_SERVICE_COUNT]=Campaign.account_service_count(report_hash[COMPANY_ID].to_i)
  end

  def add_account_media_counts(report_hash)
    report_hash[LIVE_CAMPAIGN_COUNT] = Campaign.media_active_count(report_hash[COMPANY_ID].to_i,
                                                                   report_hash[MEDIA_ID].to_i)
    report_hash[LIVE_SERVICE_COUNT]=Campaign.media_service_count(report_hash[COMPANY_ID].to_i,
                                                                 report_hash[MEDIA_ID].to_i)
  end

  def add_account_operator_counts(report_hash)
    report_hash[LIVE_CAMPAIGN_COUNT] = Campaign.operator_active_count(report_hash[COMPANY_ID].to_i,
                                                                   report_hash[OPERATOR_ID].to_i)
    report_hash[LIVE_SERVICE_COUNT]=Campaign.operator_service_count(report_hash[COMPANY_ID].to_i,
                                                                 report_hash[OPERATOR_ID].to_i)
  end

end
