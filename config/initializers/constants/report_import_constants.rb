module ReportImportConstants

	CAMPAIGN_NAME="campaign_name"
	ACQUISITION_MODEL="acquisition_model"
	MT_DAILY_APPROVED="mt_daily_approved"
	LANDING_PAGE="landing_page"
	SERVICE_CODE="service_code"
	KEYWORD="keyword"
	GATEWAY_SHARE="gateway_share"
	OPERATOR_SHARE="operator_share"
	STATUS="status"
  MSISDN="msisdn"
	OPERATOR_IDS="operator_ids"
	MEDIA_IDS="media_ids"
  LIVE_OPERATORS="live_operators"
  LIVE_MEDIA="live_media"
  LIVE_OPERATOR_COUNT="live_operator_count"
	LIVE_MEDIA_COUNT="live_media_count"
	LIVE_SERVICE_COUNT="live_service_count"
	LIVE_CAMPAIGN_COUNT="live_campaign_count"

  DOLLAR='$'
	ID_="_id"
	#Fields
	AFFILIATE_ID="affiliate_id"
	OFFER_ID="offer_id"
	MEDIA_ID="media_id"
	CAMPAIGN_ID = "campaign_id"
	OPERATOR_ID = "operator_id"
	UTC_DATE = "utc_date"
	HOUR="hour"
	MINUTE="minute"
	DATE="date"
	YEAR = "year"
	WEEK = "week"
	MONTH = "month"
	DAY = "day"
	MONTH_ID = "month_id"
	DAY_OF_YEAR = "day_of_year"
	WEEK_OF_MONTH = "week_of_month"
	WEEK_OF_YEAR = "week_of_year"
	GRAPH_ID="graph_id"

	#Different media id for accounts
	TRACKER_MEDIA=999

	# Stat Fields
	IMPRESSIONS = "impressions"
	DUPLICATE_IMPRESSIONS="duplicate_impressions"
	UNIQUE_IMPRESSIONS="unique_impressions"
	INVALID_IMPRESSIONS="invalid_impressions"
  VALID_IMPRESSIONS="valid_impressions"

	BANNER_CLICKS = "banner_clicks"
	DUPLICATE_BANNER_CLICKS="duplicate_banner_clicks"
	UNIQUE_BANNER_CLICKS="unique_banner_clicks"
	INVALID_BANNER_CLICKS="invalid_banner_clicks"
  VALID_BANNER_CLICKS="valid_banner_clicks"

	LANDING_PAGE_VIEWS = "landing_page_views"
	DUPLICATE_LANDING_PAGE_VIEWS="duplicate_landing_page_views"
	UNIQUE_LANDING_PAGE_VIEWS="unique_landing_page_views"
	INVALID_LANDING_PAGE_VIEWS="invalid_landing_page_views"
  VALID_LANDING_PAGE_VIEWS="valid_landing_page_views"

	ENGAGMENTS = "engagments"
	DUPLICATE_ENGAGMENTS="duplicate_engagments"
	UNIQUE_ENGAGMENTS="unique_engagments"
	INVALID_ENGAGMENTS="invalid_engagments"
  VALID_ENGAGMENTS="valid_engagments"

	CONVERSIONS ="conversions"
	INVALID_CONVERSIONS ="invalid_conversions"
	VALID_CONVERSIONS ="valid_conversions"

  SUBSCRIPTIONS="subscriptions"
  INVALID_SUBSCRIPTIONS="invalid_subscriptions"
  VALID_SUBSCRIPTIONS="valid_subscriptions"

	CONTENT_VIEWS="content_views"
  MEDIA_POSTBACKS="media_postbacks"
  SUBSCRIPTION_POSTBACKS="subscription_postbacks"

	OPERATOR_REPORT_DETAILS="operator_report_details"
	SUBSCRIBERS="subscribers"
  ACTIVE_SUBSCRIBERS="active_subscribers"
	UN_SUBSCRIPTIONS="un_subscriptions"

  NET_CHARGE_LOCAL = "net_charge_local"
  UNIT_CHARGE_LOCAL ="unit_charge_local"
	NET_REVENUE_LOCAL = "net_revenue_local"
	REVENUE_LOCAL = "revenue_local"
	MEDIA_COST_LOCAL = "media_cost_local"
	MEDIA_PAYOUT_LOCAL = "media_payout_local"

  NET_CHARGE_DOLLAR = "net_charge_dollar"
  UNIT_CHARGE_DOLLAR ="unit_charge_dollar"
  NET_REVENUE_DOLLAR = "net_revenue_dollar"
  REVENUE_DOLLAR = "revenue_dollar"
  MEDIA_COST_DOLLAR = "media_cost_dollar"
  MEDIA_PAYOUT_DOLLAR = "media_payout_dollar"
  AVERAGE_REVENUE_PER_SUBSCRIBER_LOCAL="average_revenue_per_subscriber_local"
  AVERAGE_REVENUE_PER_SUBSCRIBER_DOLLAR="average_revenue_per_subscriber_dollar"
  COST_PER_ACTIVE_SUBSCRIBER_DOLLAR="cost_per_active_subscriber_dollar"
  COST_PER_ACTIVE_SUBSCRIBER_LOCAL="cost_per_active_subscriber_local"

  PAUSE_ROI_LOCAL="pause_roi_local"
  PAUSE_ROI_DOLLAR="pause_roi_dollar"
  DAILY_ROI_LOCAL="daily_roi_local"
  DAILY_ROI_DOLLAR="daily_roi_dollar"

	MT_SENT="mt_sent"
	MT_SUCCESS="mt_success"
	MT_FAIL="mt_fail"
	DR_FAIL="dr_fail"
	MT_RETRY="mt_retry"
	MT_SENT_BY_OPERATOR="mt_sent_by_operator"
	MT_UNKNOWN="mt_unknown"
	DR_UNKNOWN="dr_unknown"
	MT_DELIVERED="mt_delivered"
	DR_DELIVERED="dr_delivered"
	UN_SUBSCRIPTION_DETAILS ="un_subscription_details"
	UN_SUBSCRIPTIONS_DAY="un_subscriptions_day_"
	SUBSCRIPTION_DETAILS ="subscription_details"
	SUBSCRIPTIONS_DAY="subscriptions_day_"
	COUNT="count"
	UN_SUBSCRIPTIONS_DAY_0 ="un_subscriptions_day_0"
	UN_SUBSCRIPTIONS_DAY_1 ="un_subscriptions_day_1"
	UN_SUBSCRIPTIONS_DAY_3 ="un_subscriptions_day_3"
	UN_SUBSCRIPTIONS_DAY_7 ="un_subscriptions_day_7"
	UN_SUBSCRIPTIONS_DAY_15 ="un_subscriptions_day_15"

	SUBSCRIPTIONS_DAY_0 ="subscriptions_day_0"
	SUBSCRIPTIONS_DAY_1 ="subscriptions_day_1"
	SUBSCRIPTIONS_DAY_3 ="subscriptions_day_3"
	SUBSCRIPTIONS_DAY_7 ="subscriptions_day_7"
	SUBSCRIPTIONS_DAY_15 ="subscriptions_day_15"

	SUBSCRIPTION_POSTBACK="subscription_postback"
	UN_SUBSCRIPTION_POSTBACK="un_subscription_postback"

	#deduced fields
	AVERAGE_REVENUE_PER_SUBSCRIBER="average_revenue_per_subscriber"
	COST_PER_ACTIVE_SUBSCRIBER="cost_per_active_subscriber"
	#operator percent
	MT_SENT_PERCENT="mt_sent_percent"
	NEW_SUB_UNSUB_PERCENT="new_sub_unsub_percent"
	UNSUB_PERCENT="unsub_percent"
	VALID_SUB_PERCENT="valid_sub_percent"
	SUB_RATE_PERCENT="sub_rate_percent"
	MT_SUCCESS_PERCENT="mt_success_percent"
	CONTENT_VIEW_PERCENT="content_view_percent"
  LANDING_PAGE_VALID_PERCENT="landing_page_valid_percent"

	#media percent
	VALID_ENGAGMENT_PERCENT="valid_engagment_percent"
	VALID_CLICK_PERCENT="valid_click_percent"
	#Tagging data is inserted for correcting graphs , not a valid entry
	ZERO_DATA_TAG="zero_data_tag"
	IMPORT_TYPE="importType"
	ROTATIONS ="rotations"
	RECEIVED_ROTATIONS="recv_rotations"
	SENT_CONVERSIONS="sent_conversions"
	UNSENT_CONVERSIONS="unsent_conversions"
	ROTATED_CLICKS_RECVD="rotated_clicks_recvd"
	ROTATED_CLICKS_FWD="rotated_clicks_fwd"
	ROTATED_CONVERSIONS_FWD="rotated_conversions_fwd"
	SENT_ROTATED_CONVERSIONS_FWD="sent_rotated_conversions_fwd"
	UNSENT_ROTATED_CONVERSIONS_FWD="unsent_rotated_conversions_fwd"


end
