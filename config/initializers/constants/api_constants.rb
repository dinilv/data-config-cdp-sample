module ApiConstants

  OFFSET='offset'
  LIMIT='limit'
  COUNT="count"
  TOTAL="total"
  SORT="sort"
  ORDER="order"
  CIDS="cids"
  MEIDS="meids"
  MSIDS="msids"
  OPIDS="opids"
  SDATE="sdate"
  EDATE="edate"
  CAMPAIGN="campaign"
  MEDIA="media"
  OPERATOR="operator"

  #value formatted short keys
  SUBSCRIBERS_FORMATTED="fsup"
  ACTIVE_SUBSCRIBERS_FORMATTED = "fasub"
  UN_SUBSCRIPTIONS_FORMATTED="fusub"
  VALID_SUBSCRIPTIONS_FORMATTED="fvsub"
  LANDING_PAGE_VIEWS_FORMATTED = "flpv"
  ENGAGMENTS_FORMATTED = "fe"
  BANNER_CLICKS_FORMATTED = "fbc"
  INVALID_LANDING_PAGE_VIEWS_FORMATTED = "filpv"
  INVALID_ENGAGMENTS_FORMATTED = "fie"
  INVALID_SUBSCRIPTIONS_FORMATTED = "fisup"
  MT_SENT_FORMATTED = "fmts"
  MT_SUCCESS_FORMATTED = "fmtss"
  MT_SENT_BY_OPERATOR_FORMATTED = "fmtso"
  REVENUE_LOCAL_FORMATTED="frl"
  NET_REVENUE_LOCAL_FORMATTED="fnrl"
  MEDIA_COST_LOCAL_FORMATTED="fmdcl"
  AVERAGE_REVENUE_PER_SUBSCRIBER_LOCAL_FORMATTED="farpsl"
  #max value
  SUB_MAX="msub"
  ASUB_MAX="masub"
  USUP_MAX="musup"
  VSUP_MAX="mvsup"
  NSUP_MAX="mnsup"
  #media stats
  I_MAX = "mi"
  BC_MAX = "mbc"
  IBC_MAX = "mibc"
  LPV_MAX = "mlpv"
  ILPV_MAX = "milpv"
  E_MAX = "me"
  IE_MAX = "mie"
  MS_MAX ="mms"
  MSS_MAX ="mmss"
  MSO_MAX ="mmso"
  #finance
  MDCD_MAX = "mmdcd"
  MDCL_MAX = "mmdcl"
  RD_MAX = "mrd"
  RL_MAX = "mrl"
  NRD_MAX = "mnrd"
  NRL_MAX = "mnrl"
  CPASD_MAX = "mcpasd"
  CPASL_MAX = "mcpasl"
  ARPUD_MAX = "marpud"
  ARPSL_MAX = "marpsl"


  #value factors
  ONE="1s"
  TEN="10s"
  HUNDRED="100s"
  K="1K"
  TEN_K="10K"
  HUNDRED_K="100K"
  MILLION="1M"
  TEN_MILLION="10M"
  HUNDRED_MILLION="100M"
  BILLION="1B"

  #graph axis values
  LEFT_AXIS_MAX="lam"
  RIGHT_AXIS_MAX="ram"
  LEFT_AXIS_CONV_MAX="lacm"
  LEFT_AXIS_TRAFFIC_MAX="latm"
  LEFT_AXIS_ROI_MAX="larm"
  LEFT_AXIS_BILL_MAX="labm"

  #not used
  CAMPAIGN_LIST = ["campaign_id","campaign_name","service_code","live_operator_count","live_media_count","acquisition_model","landing_page_views","engagments","subscribers","active_subscribers","mt_success","mt_sent","revenue_dollar","media_cost_dollar"]
  CAMPAIGN_DETAILS =["campaign_name","campaign_id","country","live_operators","live_media","service_code","acquisition_model","landing_page","keyword","mt_daily_approved","operator_share","gateway_share","net_revenue_dollar","subscribers","unit_charge_dollar"]
  MEDIA_PERFORMANCE=["media_name","media_payout_dollar","banner_clicks","valid_click_percent","valid_engagment_percent","subscription_postbacks","valid_sub_percent","subscriptions","un_subscriptions_day_3","un_subscriptions_day_7","un_subscriptions_day_15","active_subscriptions","new_sub_unsub_percent","mt_success_percent","media_cost_dollar","cost_per_active_subscriber_dollar"]
  OPERATOR_PERFORMANCE=["operator_name","live_media_count","net_revenue_dollar","mt_daily_approved","subscribers","subscriptions_day_3","subscriptions_day_7","subscriptions_day_15","active_subscribers","mt_sent","mt_success","mt_sent_percent","mt_success_percent","revenue_dollar","average_revenue_per_subscriber_dollar"]
  TOP_CAMPAIGNS=["campaign_name","live_operators","service_code","live_operator_count","live_media_count","acquisition_model","new_subscribers","active_subscribers","unsub_percent","valid_engagment_percent","landing_page_valid_percent","media_cost_dollar","revenue_dollar"]

  #Report
  REPORT_CAMPAIGN_MEDIA=["date","campaign_name","live_operators","campaign_id","service_code","country","live_media","acquisition_model","impressions","banner_clicks","landing_page_views","invalid_banner_clicks","engagments","invalid_engagments","valid_engagments","subscription_postbacks","invalid_conversions","media_postbacks","subscribers","active_subscribers","content_view_percent","average_revenue_per_subscriber_dollar","cost_per_active_subscriber_dollar"]
  CAMPAIGN_MONETIZATION=["date","campaign_name","campaign_id","service_code","acquisition_model","live_operator_count","live_media_count","unit_charge_dollar","subscriptions","un_subscriptions","un_subscriptions_day_3","un_subscriptions_day_7","un_subscriptions_day_15","active_subscriptions","new_sub_unsub_percent","mt_sent_percent","mt_success_percent","revenue_dollar","average_revenue_per_subscriber_dollar","cost_per_active_subscriber_dollar","pause_roi_dollar","daily_roi_dollar"]
  MEDIA_MONETIZATION=["date","media_name","live_campaign_count","service_running","impressions","banner_clicks","landing_page_views","valid_engagments","media_postbacks","subscriptions","un_subscriptions","subscriptions_day_3","subscriptions_day_7","subscriptions_day_15","active_subscribers","new_sub_unsub_percent","mt_sent_percent","mt_success_percent","revenue_dollar","average_revenue_per_subscriber_dollar","cost_per_active_subscriber_dollar","pause_roi_dollar","daily_roi_dollar"]
  OPERATOR_MONETIZATION=["date","operator_name","country","live_campaign_count","service_running","subscriptions","un_subscriptions","subscriptions_day_3","subscriptions_day_7","subscriptions_day_15","active_subscriptions","new_sub_unsub_percent","mt_request","mt_sent_percent","mt_success_percent","revenue_dollar","average_revenue_per_subscriber_dollar","cost_per_active_subscriber_dollar","pause_roi_dollar","daily_roi_dollar"]

  #dashboard
  CAMPAIGN_GRAPH =["graph_id","active_subscribers","un_subscriptions","average_revenue_per_subscriber_local"]
  PERFORMANCE_GRAPH=["graph_id","valid_engagment_percent","valid_sub_percent","mt_success_percent","content_view_percent","new_sub_unsub_percent"]

  #dashboard
  DASHBOARD_GRAPH =["graph_id","subscribers","active_subscribers","un_subscriptions","average_revenue_per_subscriber_local","average_revenue_per_subscriber_dollar",
                      "valid_subscriptions","new_sub_unsub_percent","mt_success_percent","revenue_dollar","revenue_local","net_revenue_dollar","net_revenue_local","media_cost_dollar","media_cost_local"]
  MONETIZATION_GRAPH=["live_campaign_count","live_media_count","new_subscribers","active_subscribers","total_mt_sent","total_revenue_dollar","total_media_spend","total_net_revenue_dollar"]
  MEDIA_GRAPH=["graph_id","date","media_cost_dollar"]
  CONVERSION_GRPAH=["graph_id","landing_page_views","engagments","new_subscriptions","mt_success_percent"]
  TRAFFIC_GRPAH=["graph_id","banner_clicks","invalid_landing_page_views","invalid_engagments","invalid_subscriptions"]
  BILLABLE_GRPAH=["graph_id","active_subscriptions","mt_request","mt_sent","mt_success"]
  ROI_ANALYTICS_GRPAH=["graph_id","new_subscriptions","un_subscriptions","active_subscriptions","media_cost_dollar"]

  MSISDN_REPORT=["msisdn_id","campaign_name","live_operators","service_code","country","landing_page","keyword","unit_charge_dollar","operator_name","media_name","subscription_postbacks","mt_sent","mt_success","mt_success_percent","mt_fail","mt_delivered","content_views","content_view_percent","revenue_dollar"]

end

