module AggregationConstants

  CURRENCY_SYMBOL_SHORT="c"
  GREATER_EQ_AGG_OP="$gte"
  LESS_EQ_AGG_OP="$lte"
  DOLLAR_AGG_OP="$"
  SUM_AGG_OP="$sum"
  GROUP_AGG_OP="$group"
  PROJECT_AGG_OP="$project"
  MATCH_AGG_OP="$match"
  IN_AGG_OP="$in"
  ID_="_id"
  VALUE_DOT=".v"
  VALUE_SHORT="v"
  CURRENCY_ID_SHORT="cui"
  OPERATOR_NAME_SHORT="on"
  SERVICE_RUNNING_SHORT="sc"
  ZERO_DATA_TAG_SHORT="z"
  #abbreviated constants
  # ids
  COMPANY_ID_SHORT = "cyid"
  CONTENT_PROVIDER_ID_SHORT = "cpid"
  CAMPAIGN_ID_SHORT = "cid"
  CAMPAIGN_NAME_SHORT = "cn"
  SERVICE_CODE_SHORT = "sc"
  ACQUISITION_MODEL_SHORT = "am"
  COUNTRY_SHORT = "c"
  LANDING_PAGE_SHORT = "lp"
  KEYWORD_SHORT = "ky"
  TIMEZONE_SHORT = "tz"
  OPERATOR_ID_SHORT = "oid"
  MSISDN_SHORT="msid"
  GRAPH_ID_SHORT="gid"

  #config
  GATEWAY_SHARE_SHORT = "gs"
  OPERATOR_SHARE_SHORT = "ops"
  UNIT_CHARGE_DOLLAR_SHORT = "ucd"
  NET_CHARGE_DOLLAR_SHORT = "ncd"
  UNIT_CHARGE_LOCAL_SHORT = "ucl"
  NET_CHARGE_LOCAL_SHORT = "ncl"
  #meta data
  LIVE_OPERATORS_SHORT="lo"
  LIVE_MEDIA_SHORT="lm"
  LIVE_OPERATOR_COUNT_SHORT="loc"
  LIVE_MEDIA_COUNT_SHORT="lmc"
  LIVE_CAMPAIGN_COUNT_SHORT="lcc"
  CURRENCY_SHORT="cu"
  EXCHANGE_SHORT="ex"
  OFFSET_SHORT="of"
  # for graph
  DATE_SHORT = "d"
  UTC_DATE_SHORT="ud"
  WEEK_OF_YEAR_SHORT = "wy"
  MONTH_SHORT = "m"
  MONTH_ID_SHORT = "mid"
  YEAR_SHORT = "y"
  DAY_OF_YEAR_SHORT = "dy"

  # media
  MEDIA_ID_SHORT = "meid"
  MEDIA_NAME_SHORT = "mn"
  MEDIA_PAYOUT_DOLLAR_SHORT = "mpd"
  MEDIA_PAYOUT_LOCAL_SHORT = "mpl"

  # media stats
  IMPRESSIONS_SHORT = "i"
  DUPLICATE_IMPRESSIONS_SHORT = "di"
  UNIQUE_IMPRESSIONS_SHORT = "ui"
  INVALID_IMPRESSIONS_SHORT = "ii"
  VALID_IMPRESSIONS_SHORT = "vi"

  BANNER_CLICKS_SHORT = "bc"
  DUPLICATE_BANNER_CLICKS_SHORT = "dbc"
  UNIQUE_BANNER_CLICKS_SHORT = "ubc"
  INVALID_BANNER_CLICKS_SHORT = "ibc"
  VALID_BANNER_CLICKS_SHORT = "vbc"

  LANDING_PAGE_VIEWS_SHORT = "lpv"
  DUPLICATE_LANDING_PAGE_VIEWS_SHORT = "dlpv"
  UNIQUE_LANDING_PAGE_VIEWS_SHORT = "ulpv"
  INVALID_LANDING_PAGE_VIEWS_SHORT = "ilpv"
  VALID_LANDING_PAGE_VIEWS_SHORT = "vlpv"

  ENGAGMENTS_SHORT = "e"
  DUPLICATE_ENGAGMENTS_SHORT = "de"
  UNIQUE_ENGAGMENTS_SHORT = "ue"
  INVALID_ENGAGMENTS_SHORT = "ie"
  VALID_ENGAGMENTS_SHORT = "ve"

  SUBSCRIPTIONS_SHORT = "sup"
  UN_SUBSCRIPTIONS_SHORT = "usup"
  VALID_SUBSCRIPTIONS_SHORT = "vsup"
  INVALID_SUBSCRIPTIONS_SHORT = "isup"

  INVALID_CONVERSIONS_SHORT="ic"

  CONTENT_VIEWS_SHORT = "cv"
  MEDIA_POSTBACKS_SHORT = "mp"
  SUBSCRIPTION_POSTBACKS_SHORT = "sp"

  # subscription details
  SUBSCRIBERS_SHORT = "sub"
  ACTIVE_SUBSCRIBERS_SHORT = "asub"
  NEW_SUBSCRIBERS_SHORT="nsub"

  SUBSCRIPTIONS_DAY_0_SHORT = "sup0"
  SUBSCRIPTIONS_DAY_1_SHORT = "sup1"
  SUBSCRIPTIONS_DAY_3_SHORT = "sup3"
  SUBSCRIPTIONS_DAY_7_SHORT = "sup7"
  SUBSCRIPTIONS_DAY_15_SHORT = "sup15"

  UN_SUBSCRIPTIONS_DAY_0_SHORT = "usup0"
  UN_SUBSCRIPTIONS_DAY_1_SHORT = "usup1"
  UN_SUBSCRIPTIONS_DAY_3_SHORT = "usup3"
  UN_SUBSCRIPTIONS_DAY_7_SHORT = "usup7"
  UN_SUBSCRIPTIONS_DAY_15_SHORT = "usup15"

  MT_SENT_SHORT = "mts"
  MT_FAIL_SHORT = "mtf"
  MT_SUCCESS_SHORT = "mtss"
  MT_UNKNOWN_SHORT = "mtu"
  MT_RETRY_SHORT = "mtr"
  MT_SENT_BY_OPERATOR_SHORT = "mtso"
  MT_DELIVERED_SHORT = "mtd"
  MT_REQUEST_SHORT="mtre"
  NEW_SUBSCRIPTIONS_SHORT="nsup"


  # finance fields
  MEDIA_COST_DOLLAR_SHORT = "mdcd"
  MEDIA_COST_LOCAL_SHORT = "mdcl"
  REVENUE_DOLLAR_SHORT = "rd"
  REVENUE_LOCAL_SHORT = "rl"
  TOTAL_REVENUE_DOLLAR_SHORT="trd"
  TOTAL_NET_REVENUE_DOLLAR_SHORT="tnrd"
  NET_REVENUE_DOLLAR_SHORT = "nrd"
  NET_REVENUE_LOCAL_SHORT = "nrl"
  COST_PER_ACTIVE_SUBSCRIBER_DOLLAR_SHORT = "cpasd"
  COST_PER_ACTIVE_SUBSCRIBER_LOCAL_SHORT = "cpasl"
  AVERAGE_REVENUE_PER_SUBSCRIBER_DOLLAR_SHORT = "arpsd"
  AVERAGE_REVENUE_PER_SUBSCRIBER_LOCAL_SHORT = "arpsl"

  #analysed fields
  PAUSE_ROI_DOLLAR_SHORT = "proid"
  PAUSE_ROI_LOCAL_SHORT = "proil"
  DAILY_ROI_DOLLAR_SHORT = "droid"
  DAILY_ROI_LOCAL_SHORT = "droil"

  # deduced fields
  VALID_CLICK_PERCENT_SHORT = "vcp"
  CONTENT_VIEW_PERCENT_SHORT = "cvp"
  SUB_RATE_PERCENT_SHORT = "srp"
  VALID_SUB_PERCENT_SHORT = "vsp"
  NEW_SUB_UNSUB_PERCENT_SHORT = "nsup"
  UNSUB_PERCENT_SHORT = "up"
  VALID_ENGAGMENT_PERCENT_SHORT = "vep"
  LANDING_PAGE_VALID_PERCENT_SHORT = "lpvp"
  MT_SUCCESS_PERCENT_SHORT = "mssp"
  MT_SENT_PERCENT_SHORT = "mtsp"
  ACTIVE_SUBSCRIPTIONS_SHORT="asup"


  OPERATOR_NAME="on"


end