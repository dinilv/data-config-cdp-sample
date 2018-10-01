module ReportConstants

  #report headers with currency
  MSISDN_REPORT_HEADERS=["MSISDN","CAMPAIGN","SERVCIE CODE","COUNTRY","ACQUISITION MODEL","LANDING PAGE",
  "KEYWORD","UNIT CHARGE LOCAL(<currency>)","UNIT CHARGE DOLLAR($)","OPERATOR","MEDIA","SUBSCRIPTIONS",
 "MT SENT(#)","MT SUCCESS(#)", "MT SUCCESS(%)","MT FAILED(#)","MT DELIVERED(#)",
                         "CONTENT VIEWS(#)","CONTENT VIEW(%)","REVENUE LOCAL(<currency>)","REVENUE DOLLAR($)",
                          "COST PER SUBSCRIPTION LOCAL(<currency>)","COST PER SUBSCRIPTION DOLLAR($)"]

  #report fields
  MSISDN_REPORT_FIELDS=[ "_id.msid","_id.cid","_id.cn","_id.sc","_id.c","_id.am","_id.lp","_id.ky","ucl","ucd","_id.on",
                         "_id.mn","sup","mts","mtss","mssp","mtf",
                  "mtd","cv","cvp","rl","rd","cpasl","cpasd"]


  CAMPAIGN_TRAFFIC_HEADERS=["DATE","CAMPAIGN","CAMPAIGN ID","SERVCIE CODE","COUNTRY","MEDIA",
                            "ACQUISITION MODEL","IMPRESSIONS(#)","BANNER CLICKS(#)",
                            "LANDING PAGE VIEW(#)","INVALID BANNER CLICKS(#)","ENGAGEMENTS(#)",
                           "INVALID ENGAGMENTS(#)","VALID ENGAGED(#)",
                            "SUBSCRIPTION POSTBACKS(#)","INVALID SUBSCRIPTIONS(#)",
                            "MEDIA POSTBACKS(#)" ,"SUBSCRIBERS(#)",
                            "ACTIVE SUBSCRIBERS(#)","CONTENT VIEW(%)",
                            "AVERAGE REVENUE PER SUBSCRIBER LOCAL(<currency>)",
                            "AVERAGE REVENUE PER SUBSCRIBER DOLLAR($)",
                            "COST PER ACTIVE SUBSCRIBER LOCAL(<currency>)",
                            "COST PER ACTIVE SUBSCRIBER DOLLAR($)"]

  CAMPAIGN_TRAFFIC_FIELDS=["_id.d","_id.cn","_id.cid","_id.sc","_id.c","_id.mn","_id.am","i","bc","lpv",
                           "ibc","e","ie","ve","sp","mp","sub","asub",
                           "cvp","arpsl","arpsd","cpasl","cpasd"]

  CAMPAIGN_MONETIZATION_HEADERS=["DATE","CAMPAIGN","CAMPAIGN ID","SERVCIE CODE",
                                 "ACQUISITION MODEL","LIVE OPERATOR COUNT(#)",
                                 "LIVE MEDIA COUNT(#)","UNIT CHARGE LOCAL(<currency>)",
                                 "UNIT CHARGE DOLLAR($)","SUBSCRIPTIONS(#)","UN SUBSCRIPTIONS(#)",
                                 "3 DAYS USUBSCRIPTIONS(#)","7 DAYS USUBSCRIPTIONS(#)",
                                 "15 DAYS USUBSCRIPTIONS(#)","ACTIVE SUBSCRIBERS(#)",
                                 "NEW SUBSCRIBERS UNSUBSCRIPTIONS(%)","MT SENT(%)","MT SUCCESS(%)",
                                 "REVENUE LOCAL(<currency>)","REVENUE DOLLAR($)",
                                 "AVERAGE REVENUE PER SUBSCRIBERS LOCAL(<currency>)",
                                 "AVERAGE REVENUE PER SUBSCRIBERS DOLLAR($)",
                                 "COST PER ACTIVE SUBSCRIBER LOCAL(<currency>)",
                                 "COST PER ACTIVE SUBSCRIBER DOLLAR($)","PAUSE ROI LOCAL(<currency>)",
                                 "PAUSE ROI DOLLAR($)","DAILY ROI LOCAL(<currency>)","DAILY ROI DOLLAR($)"]

  CAMPAIGN_MONETIZATION_FIELDS=["_id.d","_id.cn","_id.cid","_id.sc","_id.am","_id.loc","_id.lmc","ucl",
                           "ucd","sup","usup","usup3","usup7","usup15","asub","nsup",
                           "mtsp","mssp","rl","rd","arpsl","arpsd","cpasl","cpasd","proil","proid","droil","droid"]

  MEDIA_MONETIZATION_HEADERS=["DATE","MEDIA","LIVE CAMPAIGN COUNT(#)","LIVE SERVICE COUNT(#)","IMPRESSIONS(#)",
                              "BANNER CLICKS(#)","LANDING PAGE VIEWS(#)","VALID ENGAGMENTS(#)","MEDIA POSTBACKS(#)",
                              "SUBSCRIPTIONS(#)","UN SUBSCRIPTIONS(#)",
                              "3 DAYS UNSUBSCRIPTIONS(#)","7 DAYS UNSUBSCRIPTIONS(#)",
                              "15 DAYS UNSUBSCRIPTIONS(#)","ACTIVE SUBSCRIBERS(#)","NEW SUBSCRIBERS UNSUBSCRIPTIONS(%)",
                              "MT SENT(%)","MT SUCCESS(%)","REVENUE LOCAL(<currency>)","REVENUE DOLLAR($)",
                              "AVERAGE REVENUE PER SUBSCRIBERS LOCAL(<currency>)",
                              "AVERAGE REVENUE PER SUBSCRIBERS DOLLAR($)","COST PER ACTIVE SUBSCRIBER LOCAL(<currency>)",
                              "COST PER ACTIVE SUBSCRIBER DOLLAR($)","PAUSE ROI LOCAL(<currency>)",
                              "PAUSE ROI DOLLAR($)","DAILY ROI LOCAL(<currency>)","DAILY ROI DOLLAR($)"]

  MEDIA_MONETIZATION_FIELDS=["_id.d","_id.mn","_id.lcc","_id.lsc","i","bc",
                             "lpv","ve","mp","sup","usup","usup3","usup7","usup15","asub","nsup","mtsp","mssp","rl",
                             "rd","arpsl","arpsd","cpasl","cpasd","proil","proid","droil","droid"]


  OPERATOR_MONETIZATION_HEADERS=["DATE","OPERATOR","COUNTRY","LIVE CAMPAIGN COUNT(#)",
                         "LIVE SERVICE COUNT(#)","SUBSCRIPTIONS(#)",
                         "UN SUBSCRIPTIONS(#)","3 DAYS UNSUBSCRIPTIONS(#)",
                         "7 DAYS UNSUBSCRIPTIONS(#)","15 DAYS UNSUBSCRIPTIONS(#)",
                         "ACTIVE SUBSCRIBERS(#)","NEW SUBSCRIBERS UNSUBSCRIPTIONS(%)",
                         "MT SEND BY OPERATOR(#)","MT SENT(%)","MT  SUCCESS(%)",
                         "REVENUE LOCAL(<currency>)","REVENUE DOLLAR($)",
                         "PAUSE ROI LOCAL(<currency>)",
                         "PAUSE ROI DOLLAR($)","DAILY ROI LOCAL(<currency>)","DAILY ROI DOLLAR($)"]

  OPERATOR_MONETIZATION_FIELDS=["_id.d","_id.on","_id.c","_id.lcc","_id.lsc","sup","usup","usup3","usup5","usup7",
                                "usup15","asub","nsup","mtso","mtsp","mssp","rl","rd","proil","proid","droil","droid"]

end

