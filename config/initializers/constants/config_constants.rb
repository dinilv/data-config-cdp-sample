module ConfigConstants
  #company
  ADMIN_ACCOUNT="1"
  #
  LIST_KEY="active_token"
  COMPANY_ID="company_id"
  COMPANY_NAME="company_name"
  #redis keys
  CAMPAIGN_IDS="campaign_ids"
  MEDIA="media"
  COUNTRY="country"
  CATEGORY="category"



  #operator
  OPERATOR_ID="operator_id"
  OPERATOR_NAME="operator_name"
  OPERATOR_KEY="operator_key"
  OPERATOR_COUNTRY="operator_country"
  OPERATOR_STATUS="status"
  CURRENCY="currency"
  CURRENCY_ID="currency_id"

  #user verification
  ACCOUNT_VERIFICATION='http://cmp.iiris.io/auth/verify?token='

  #content_provider
  #campaign
  CAMPAIGN_CREATED_BY="Campaign created by"
  CAMPAIGN_CREATED="Campaign created"
  CAMPAIGN_ID="campaign_id"
  CAMPAIGN_NAME="campaign_name"
  CAMPAIGN_COUNTRY="country"
  CAMPAIGN_COUNTRY_ID="country_id"
  CREATED_BY="created_by"
  UPDATED_BY="updated_by"
  ACQUISITION_MODEL="acquisition_model"
  MT_DAILY_APPROVED="mt_daily_approved"
  OPERATORS="operators"
  CAMPAIGN_TYPE="category"
  LANDING_PAGE="landing_page"
  SERVICE_CODE="service_code"
  KEYWORD="keyword"
  UNIT_CHARGE_DOLLAR="unit_charge_dollar"
  UNIT_CHARGE_LOCAL="unit_charge_local"
  UNIT_CHARGE="unit_charge"
  NET_CHARGE="net_charge"
  NET_CHARGE_DOLLAR="net_charge_dollar"
  NET_CHARGE_LOCAL="net_charge_local"
  GATEWAY_SHARE="gateway_share"
  OPERATOR_SHARE="operator_share"
  CAMPAIGN_STATUS="status"
  MEDIA_DETAILS="media_details"
  CONTENT_PROVIDER_ID='content_provider_id'
  CAMPAIGN_LANDING_URL="landing_url"
  CAMPAIGN_MIGRATED_BY="Campaign migrated by"
  ID="id"


  AUTHORIZATION="Authorization"
  AUTHORIZATION_STATUS="Please login to continue"
  UNAUTHORIZATION='Not authorized, to view this page'
  UNAUTHORIZATION_ADMIN='Not authorized as admin, to view this page'
  AUTH_TOKEN='token:'
  TOKEN_EXPIRED='token expired'

  MEDIA_CAP="media_cap"
  MEDIA_PAYOUT_DOLLAR="media_payout_dollar"
  MEDIA_PAYOUT_LOCAL="media_payout_local"
  MEDIA_PAYOUT="media_payout"

  MEDIA_LINK="media_link"
  MEDIA_STATUS ="status"

  MEDIA_NAME="media_name"
  MEDIA_TEMPLATE="media_template"
  MEDIA_ID="media_id"
  MEDIA_COUNTRYIDS="countryIDs"

  EMAIL='email'
  ROLE ='role'
  IS_FIRST='is_first_login'
  FIRST_NAME='first_name'
  TIMEZONE_ID='timezone_id'
  LANGUAGE_ID ='language_id'
  COUNTRY_ID='country_id'
  MEMBER_ID='member_id'
  TOKEN='token'
  UPDATED_AT="updated_at"
  CARD_DETAILS="card_details"
  USER_ID="user_id"

  CAMPAIGN_ACQUISITION_TYPE=Hash.[](
      0 => "WAP",
      1 => "SMS",
      2 => "IVR",
      3=>"USSD"
  )

  #For localisation
  TIMEZONE_DIFFERENCE = Hash.[](

    0 => "0:0",
    1 => "7:00",
    2 => "5:30"
    )

    CURRENCY_EXCHANGE = Hash.[](

      0 => 1,
      1 => 31.20,
      2 => 65.40
      )

  Media_key = Hash.[](

      0 => "media_id",
      2 => "media_cap",
      3 => "media_payout_dollar",
      4 => "media_payout_local",


  )
  Operator_key = Hash.[](

      1 => "operator_name",
      2=> "operator_key",
      3=>"operator_country",
      4=>"status"
  )

  MEDIA_KEY = Hash.[](

      0 => 'media_name',
      1 => "media_template",
      2 => "countryIDs",
      3 =>  "status"

  )
  CAMPAIGN_KEY =Hash.[](

      0 => 'mt_daily_approved',
      1 => "landing_page",
      3 =>  "status",
      4 => 'mt_daily_approved',
      5 => "landing_page",
      7 =>  "service_code",
      8 => "campaign_name",
      9=>"operator_share",
      10=>"gateway_share",
      11=> "acquisition_model",
      12=>"keyword"




  )
  CONTENT_PROVIDER_KEY=Hash.[](

      0 => "first_name",
      1 => "last_name",
      2 => "company_name",
      3 =>  "contact",
      4 => "country",
      5 => "timezone",
      6 => "currency",
      7 =>  "language",
      8 => "api_limit",
      9 => "click_limit",
      10=> "plan",
      11=>"company_tax_number",
      12=>  "company_registered_address",
      13 => "company_billing_address"

  )

  CURRENCY_CODE =Hash.[](
       1=>"$(USD)",
       2=>"CA$(CAD)",
       3=>"€(EUR)",
       4=>"AED(AED)",
       5=>"Af(AFN)",
       6=>"ALL(ALL)",
       7=>"AMD(AMD)",
       8=>"AR$(ARS)",
       9=>"AU$(AUD)",
       10=>"man.(AZN)",
       11=>"KM(BAM)",
       12=>"Tk(BDT)",
       13=>"BGN(BGN)",
       14=>"BD(BHD)",
       15=>"FBu(BIF)",
       16=>"BN$(BND)",
       17=>"Bs(BOB)",
       18=>"R$(BRL)",
       19=>"BWP(BWP)",
       20=>"BYR(BYR)",
       21=>"BZ$(BZD)",
       22=>"CDF(CDF)",
       23=>"CHF(CHF)",
       24=>"CL$(CLP)",
       25=>"CN¥(CNY)",
       26=>"CO$(COP)",
       27=>"₡(CRC)",
       28=>"CV$(CVE)",
       29=>"Kč(CZK)",
       30=>"Fdj(DJF)",
       31=>"Dkr(DKK)",
       32=>"RD$(DOP)",
       33=>"DA(DZD)",
       34=>"Ekr(EEK)",
       35=>"EGP(EGP)",
       36=>"Nfk(ERN)",
       37=>"Br(ETB)",
       38=>"£(GBP)",
       39=>"GEL(GEL)",
       40=>"GH₵(GHS)",
       41=>"FG(GNF)",
       42=>"GTQ(GTQ)",
       43=>"HK$(HKD)",
       44=>"HNL(HNL)",
       45=>"kn(HRK)",
       46=>"Ft(HUF)",
       47=>"Rp(IDR)",
       48=>"₪(ILS)",
       49=>"Rs(INR)",
       50=>"IQD(IQD)",
       51=>"IRR(IRR)",
       52=>"Ikr(ISK)",
       53=>"J$(JMD)",
       54=>"JD(JOD)",
       55=>"¥(JPY)",
       56=>"Ksh(KES)",
       57=>"KHR(KHR)",
       58=>"CF(KMF)",
       59=>"₩(KRW)",
       60=>"KD(KWD)",
       61=>"KZT(KZT)",
       62=>"LB£(LBP)",
       63=>"SLRs(LKR)",
       64=>"Lt(LTL)",
       65=>"Ls(LVL)",
       66=>"LD(LYD)",
       67=>"MAD(MAD)",
       68=>"MDL(MDL)",
       69=>"MGA(MGA)",
       70=>"MKD(MKD)",
       71=>"MMK(MMK)",
       72=>"MOP$(MOP)",
       73=>"MURs(MUR)",
       74=>"MX$(MXN)",
       75=>"RM(MYR)",
       76=>"MTn(MZN)",
       77=>"N$(NAD)",
       78=>"₦(NGN)",
       79=>"C$(NIO)",
       80=>"Nkr(NOK)",
       81=>"NPRs(NPR)",
       82=>"NZ$(NZD)",
       83=>"OMR(OMR)",
       84=>"B/.(PAB)",
       85=>"S/.(PEN)",
       86=>"₱(PHP)",
       87=>"PKRs(PKR)",
       88=>"zł(PLN)",
       89=>"₲(PYG)",
       90=>"QR(QAR)",
       91=>"RON(RON)",
       92=>"din.(RSD)",
       93=>"RUB(RUB)",
       94=>"RWF(RWF)",
       95=>"SR(SAR)",
       96=>"SDG(SDG)",
       97=>"Skr(SEK)",
       98=>"S$(SGD)",
       99=>"Ssh(SOS)",
       100=>"SY£(SYP)",
       101=>"฿(THB)",
       102=>"DT(TND)",
       103=>"T$(TOP)",
       104=>"TL(TRY)",
       105=>"TT$(TTD)",
       106=>"NT$(TWD)",
       107=>"TSh(TZS)",
       108=>"₴(UAH)",
       109=>"USh(UGX)",
       110=>"$U(UYU)",
       111=>"UZS(UZS)",
       112=>"Bs.F.(VEF)",
       113=>"₫(VND)",
       114=>"FCFA(XAF)",
       115=>"CFA(XOF)",
       116=>"YR(YER)",
       117=>"R(ZAR)",
       118=>"ZK(ZMK)"

  )

  CURRENCY_SYMBOL=Hash.[](
      1=>"$",
      2=>"CA$",
      3=>"€",
      4=>"AED",
      5=>"Af",
      6=>"ALL",
      7=>"AMD",
      8=>"AR$",
      9=>"AU$",
      10=>"man.",
      11=>"KM",
      12=>"Tk",
      13=>"BGN",
      14=>"BD",
      15=>"FBu",
      16=>"BN$",
      17=>"Bs",
      18=>"R$",
      19=>"BWP",
      20=>"BYR",
      21=>"BZ$",
      22=>"CDF",
      23=>"CHF",
      24=>"CL$",
      25=>"CN¥",
      26=>"CO$",
      27=>"₡",
      28=>"CV$",
      29=>"Kč",
      30=>"Fdj",
      31=>"Dkr",
      32=>"RD$",
      33=>"DA",
      34=>"Ekr",
      35=>"EGP",
      36=>"Nfk",
      37=>"Br",
      38=>"£",
      39=>"GEL",
      40=>"GH₵",
      41=>"FG",
      42=>"GTQ",
      43=>"HK$",
      44=>"HNL",
      45=>"kn",
      46=>"Ft",
      47=>"Rp",
      48=>"₪",
      49=>"Rs",
      50=>"IQD",
      51=>"IRR",
      52=>"Ikr",
      53=>"J$",
      54=>"JD",
      55=>"¥",
      56=>"Ksh",
      57=>"KHR",
      58=>"CF",
      59=>"₩",
      60=>"KD",
      61=>"KZT",
      62=>"LB£",
      63=>"SLRs",
      64=>"Lt",
      65=>"Ls",
      66=>"LD",
      67=>"MAD",
      68=>"MDL",
      69=>"MGA",
      70=>"MKD",
      71=>"MMK",
      72=>"MOP$",
      73=>"MURs",
      74=>"MX$",
      75=>"RM",
      76=>"MTn",
      77=>"N$",
      78=>"₦",
      79=>"C$",
      80=>"Nkr",
      81=>"NPRs",
      82=>"NZ$",
      83=>"OMR",
      84=>"B/.",
      85=>"S/.",
      86=>"₱",
      87=>"PKRs",
      88=>"zł",
      89=>"₲",
      90=>"QR",
      91=>"RON",
      92=>"din.",
      93=>"RUB",
      94=>"RWF",
      95=>"SR",
      96=>"SDG",
      97=>"Skr",
      98=>"S$",
      99=>"Ssh",
      100=>"SY£",
      101=>"฿",
      102=>"DT",
      103=>"T$",
      104=>"TL",
      105=>"TT$",
      106=>"NT$",
      107=>"TSh",
      108=>"₴",
      109=>"USh",
      110=>"$U",
      111=>"UZS",
      112=>"Bs.F.",
      113=>"₫",
      114=>"FCFA",
      115=>"CFA",
      116=>"YR",
      117=>"R",
      118=>"ZK"

  )

  CURRENCY_ID_MAP=Hash.[](

  "USDUSD"=>1,
   "USDCAD"=>2,
   "USDEUR"=>3, "USDAED"=>4, "USDAFN"=>5,
  "USDALL"=>6, "USDAMD"=>7, "USDARS"=>8, "USDAUD"=>9,
  "USDAZN"=>10, "USDBAM"=>11, "USDBDT"=>12,
  "USDBGN"=>13, "USDBHD"=>14, "USDBIF"=>15,
  "USDBND"=>16, "USDBOB"=>17, "USDBRL"=>18,
  "USDBWP"=>19, "USDBYR"=>20, "USDBZD"=>21,
  "USDCDF"=>22, "USDCHF"=>23, "USDCLP"=>24,
  "USDCNY"=>25, "USDCOP"=>26, "USDCRC"=>27,
  "USDCVE"=>28, "USDCZK"=>29, "USDDJF"=>30,
  "USDDKK"=>31, "USDDOP"=>32, "USDDZD"=>33,
  "USDEEK"=>34, "USDEGP"=>35, "USDERN"=>36,
  "USDETB"=>37, "USDGBP"=>38, "USDGEL"=>39,
  "USDGHS"=>40, "USDGNF"=>41, "USDGTQ"=>42,
  "USDHKD"=>43, "USDHNL"=>44, "USDHRK"=>45,
  "USDHUF"=>46, "USDIDR"=>47, "USDILS"=>48,
  "USDINR"=>49, "USDIQD"=>50, "USDIRR"=>51,
  "USDISK"=>52, "USDJMD"=>53, "USDJOD"=>54,
  "USDJPY"=>55, "USDKES"=>56, "USDKHR"=>57,
  "USDKMF"=>58, "USDKRW"=>59, "USDKWD"=>60,
  "USDKZT"=>61, "USDLBP"=>62, "USDLKR"=>63,
  "USDLTL"=>64, "USDLVL"=>65, "USDLYD"=>66,
  "USDMAD"=>67, "USDMDL"=>68, "USDMGA"=>69,
  "USDMKD"=>70, "USDMMK"=>71, "USDMOP"=>72,
  "USDMUR"=>73, "USDMXN"=>74, "USDMYR"=>75,
  "USDMZN"=>76, "USDNAD"=>77, "USDNGN"=>78,
  "USDNIO"=>79, "USDNOK"=>80, "USDNPR"=>81,
  "USDNZD"=>82, "USDOMR"=>83, "USDPAB"=>84,
  "USDPEN"=>85, "USDPHP"=>86, "USDPKR"=>87,
  "USDPLN"=>88, "USDPYG"=>89, "USDQAR"=>90,
  "USDRON"=>91, "USDRSD"=>92, "USDRUB"=>93,
  "USDRWF"=>94, "USDSAR"=>95, "USDSDG"=>96,
  "USDSEK"=>97, "USDSGD"=>98, "USDSOS"=>99,
  "USDSYP"=>100, "USDTHB"=>101, "USDTND"=>102,
  "USDTOP"=>103, "USDTRY"=>104, "USDTTD"=>105,
  "USDTWD"=>106, "USDTZS"=>107, "USDUAH"=>108,
  "USDUGX"=>109, "USDUYU"=>110, "USDUZS"=>111,
  "USDVEF"=>112, "USDVND"=>113, "USDXAF"=>114,
  "USDXOF"=>115, "USDYER"=>116, "USDZAR"=>117,
  "USDZMK"=>118)

CURRENCY_MAP=Hash.[](
  1=>"USDUSD",2=>"USDCAD",
  3=>"USDEUR", 4=>"USDAED",
  5=>"USDAFN", 6=>"USDALL",
  7=>"USDAMD", 8=>"USDARS",
  9=>"USDAUD", 10=>"USDAZN",
  11=>"USDBAM", 12=>"USDBDT",
  13=>"USDBGN", 14=>"USDBHD",
  15=>"USDBIF", 16=>"USDBND",
  17=>"USDBOB", 18=>"USDBRL",
  19=>"USDBWP", 20=>"USDBYR",
  21=>"USDBZD", 22=>"USDCDF",
  23=>"USDCHF", 24=>"USDCLP",
  25=>"USDCNY", 26=>"USDCOP",
  27=>"USDCRC", 28=>"USDCVE",
  29=>"USDCZK", 30=>"USDDJF",
  31=>"USDDKK", 32=>"USDDOP",
  33=>"USDDZD", 34=>"USDEEK",
  35=>"USDEGP", 36=>"USDERN",
  37=>"USDETB", 38=>"USDGBP",
  39=>"USDGEL", 40=>"USDGHS",
  41=>"USDGNF", 42=>"USDGTQ",
  43=>"USDHKD", 44=>"USDHNL",
  45=>"USDHRK", 46=>"USDHUF",
  47=>"USDIDR", 48=>"USDILS",
  49=>"USDINR", 50=>"USDIQD",
  51=>"USDIRR", 52=>"USDISK",
  53=>"USDJMD", 54=>"USDJOD",
  55=>"USDJPY", 56=>"USDKES",
  57=>"USDKHR", 58=>"USDKMF",
  59=>"USDKRW", 60=>"USDKWD",
  61=>"USDKZT", 62=>"USDLBP",
  63=>"USDLKR", 64=>"USDLTL",
  65=>"USDLVL", 66=>"USDLYD",
  67=>"USDMAD", 68=>"USDMDL",
  69=>"USDMGA", 70=>"USDMKD",
  71=>"USDMMK", 72=>"USDMOP",
  73=>"USDMUR", 74=>"USDMXN",
  75=>"USDMYR", 76=>"USDMZN",
  77=>"USDNAD", 78=>"USDNGN",
  79=>"USDNIO", 80=>"USDNOK",
  81=>"USDNPR", 82=>"USDNZD",
  83=>"USDOMR", 84=>"USDPAB",
  85=>"USDPEN", 86=>"USDPHP",
  87=>"USDPKR", 88=>"USDPLN",
  89=>"USDPYG", 90=>"USDQAR",
  91=>"USDRON", 92=>"USDRSD",
  93=>"USDRUB", 94=>"USDRWF",
  95=>"USDSAR", 96=>"USDSDG",
  97=>"USDSEK", 98=>"USDSGD",
  99=>"USDSOS", 100=>"USDSYP",
  101=>"USDTHB", 102=>"USDTND",
  103=>"USDTOP", 104=>"USDTRY",
  105=>"USDTTD", 106=>"USDTWD",
  107=>"USDTZS", 108=>"USDUAH",
  109=>"USDUGX", 110=>"USDUYU",
  111=>"USDUZS", 112=>"USDVEF",
  113=>"USDVND", 114=>"USDXAF",
  115=>"USDXOF", 116=>"USDYER",
  117=>"USDZAR", 118=>"USDZMK"
  )


  TIME_ZONE=Hash.new(
      0=>"UTC", 1=>"Hawaiian Standard Time(UTC-10:00) Hawaii",
      2=>"US Mountain Standard Time(UTC-07:00) Arizona",
      3=>"Central America Standard Time(UTC-06:00) Central America",
      4=>"Canada Central Standard Time(UTC-06:00) Saskatchewan",
      5=>"SA Pacific Standard Time(UTC-05:00) Bogota, Lima, Quito",
      6=>"Venezuela Standard Time(UTC-04:30) Caracas",
      7=>"Paraguay Standard Time(UTC-04:00) Asuncion",
      8=>"Central Brazilian Standard Time(UTC-04:00) Cuiaba",
      9=>"SA Western Standard Time(UTC-04:00) Georgetown, La Paz, Manaus, San Juan",
      10=>"Pacific SA Standard Time(UTC-04:00) Santiago",
      11=>"E. South America Standard Time(UTC-03:00) Brasilia",
      12=>"Argentina Standard Time(UTC-03:00) Buenos Aires",
      13=>"SA Eastern Standard Time(UTC-03:00) Cayenne, Fortaleza",
      14=>"Montevideo Standard Time(UTC-03:00) Montevideo",
      15=>"Bahia Standard Time(UTC-03:00) Salvador", 16=>"UTC-02(UTC-02:00) Coordinated Universal Time-02",
      17=>"Cape Verde Standard Time(UTC-01:00) Cape Verde Is.", 18=>"UTC(UTC) Coordinated Universal Time",
      19=>"Greenwich Standard Time(UTC) Monrovia, Reykjavik",
      20=>"W. Central Africa Standard Time(UTC+01:00) West Central Africa",
      21=>"Namibia Standard Time(UTC+01:00) Windhoek",
      22=>"Egypt Standard Time(UTC+02:00) Cairo", 23=>"South Africa Standard Time(UTC+02:00) Harare, Pretoria",
      24=>"Turkey Standard Time(UTC+03:00) Istanbul", 25=>"Libya Standard Time(UTC+02:00) Tripoli",
      26=>"Jordan Standard Time(UTC+03:00) Amman", 27=>"Arabic Standard Time(UTC+03:00) Baghdad",
      28=>"Kaliningrad Standard Time(UTC+03:00) Kaliningrad, Minsk", 29=>"Arab Standard Time(UTC+03:00) Kuwait, Riyadh", 30=>"E. Africa Standard Time(UTC+03:00) Nairobi",
      31=>"Moscow Standard Time(UTC+03:00) Moscow, St. Petersburg, Volgograd",
      32=>"Samara Time(UTC+04:00) Samara, Ulyanovsk, Saratov",
      33=>"Arabian Standard Time(UTC+04:00) Abu Dhabi, Muscat",
      34=>"Mauritius Standard Time(UTC+04:00) Port Louis",
      35=>"Georgian Standard Time(UTC+04:00) Tbilisi",
      36=>"Caucasus Standard Time(UTC+04:00) Yerevan",
      37=>"Afghanistan Standard Time(UTC+04:30) Kabul",
      38=>"West Asia Standard Time(UTC+05:00) Ashgabat, Tashkent",
      39=>"Pakistan Standard Time(UTC+05:00) Islamabad, Karachi",
      40=>"India Standard Time(UTC+05:30) Chennai, Kolkata, Mumbai, New Delhi",
      41=>"Sri Lanka Standard Time(UTC+05:30) Sri Jayawardenepura", 42=>"Nepal Standard Time(UTC+05:45) Kathmandu",
      43=>"Central Asia Standard Time(UTC+06:00) Astana", 44=>"Bangladesh Standard Time(UTC+06:00) Dhaka",
      45=>"Ekaterinburg Standard Time(UTC+06:00) Ekaterinburg",
      46=>"Myanmar Standard Time(UTC+06:30) Yangon (Rangoon)",
      47=>"SE Asia Standard Time(UTC+07:00) Bangkok, Hanoi, Jakarta",
      48=>"N. Central Asia Standard Time(UTC+07:00) Novosibirsk",
      49=>"China Standard Time(UTC+08:00) Beijing, Chongqing, Hong Kong, Urumqi",
      50=>"North Asia Standard Time(UTC+08:00) Krasnoyarsk",
      51=>"Singapore Standard Time(UTC+08:00) Kuala Lumpur, Singapore",
      52=>"W. Australia Standard Time(UTC+08:00) Perth",
      53=>"Taipei Standard Time(UTC+08:00) Taipei",
      54=>"Ulaanbaatar Standard Time(UTC+08:00) Ulaanbaatar",
      55=>"North Asia East Standard Time(UTC+09:00) Irkutsk",
      56=>"Tokyo Standard Time(UTC+09:00) Osaka, Sapporo, Tokyo",
      57=>"Korea Standard Time(UTC+09:00) Seoul",
      58=>"Cen. Australia Standard Time(UTC+09:30) Adelaide",
      59=>"AUS Central Standard Time(UTC+09:30) Darwin",
      60=>"E. Australia Standard Time(UTC+10:00) Brisbane",
      61=>"AUS Eastern Standard Time(UTC+10:00) Canberra, Melbourne, Sydney",
      62=>"West Pacific Standard Time(UTC+10:00) Guam, Port Moresby",
      63=>"Tasmania Standard Time(UTC+10:00) Hobart", 64=>"Yakutsk Standard Time(UTC+10:00) Yakutsk",
      65=>"Central Pacific Standard Time(UTC+11:00) Solomon Is., New Caledonia",
      66=>"Vladivostok Standard Time(UTC+11:00) Vladivostok",
      67=>"New Zealand Standard Time(UTC+12:00) Auckland, Wellington",
      68=>"UTC+12(UTC+12:00) Coordinated Universal Time+12", 69=>"Fiji Standard Time(UTC+12:00) Fiji",
      70=>"Magadan Standard Time(UTC+12:00) Magadan",
      71=>"Tonga Standard Time(UTC+13:00) Nuku'alofa",
      72=>"Samoa Standard Time(UTC+13:00) Samoa"
  )

  TIME_OFFSET=Hash.[](
      0=>0, 1=>-35100, 2=>-24300,
      3=>-20700, 4=>-20700, 5=>-17100,
      6=>-15300.0, 7=>-13500, 8=>-13500,
      9=>-13500, 10=>-13500, 11=>-9900,
      12=>-9900, 13=>-9900, 14=>-9900,
      15=>-9900, 16=>-6300, 17=>-2700,
      18=>0, 19=>0, 20=>4500, 21=>4500,
      22=>8100, 23=>8100, 24=>11700, 25=>8100,
      26=>11700, 27=>11700, 28=>11700, 29=>11700,
      30=>11700, 31=>11700, 32=>15300, 33=>15300,
      34=>15300, 35=>15300, 36=>15300, 37=>17100.0,
      38=>18900, 39=>18900, 40=>20700.0, 41=>20700.0,
      42=>21600.0, 43=>22500, 44=>22500, 45=>22500,
      46=>24300.0, 47=>26100, 48=>26100, 49=>29700,
      50=>29700, 51=>29700, 52=>29700, 53=>29700,
      54=>29700, 55=>33300, 56=>33300, 57=>33300,
      58=>35100.0, 59=>35100.0, 60=>36900, 61=>36900,
      62=>36900, 63=>36900, 64=>36900, 65=>40500,
      66=>40500, 67=>44100, 68=>44100, 69=>44100,
      70=>44100, 71=>47700, 72=>47700
  )

  TIME_HOUR_MAP=Hash.[](0=>"0_0", 1=>"-10_0", 2=>"-7_0", 3=>"-6_0", 4=>"-6_0",
                        5=>"-5_0", 6=>"-4_0", 7=>"-4_0", 8=>"-4_0", 9=>"-4_0",
                        10=>"-4_0", 11=>"-3_0", 12=>"-3_0", 13=>"-3_0", 14=>"-3_0",
                        15=>"-3_0", 16=>"-2_0", 17=>"-1_0", 18=>"0_0", 19=>"0_0", 20=>"1_0",
                        21=>"1_0", 22=>"2_0", 23=>"2_0", 24=>"3_0", 25=>"2_0", 26=>"3_0",
                        27=>"3_0", 28=>"3_0", 29=>"3_0", 30=>"3_0", 31=>"3_0", 32=>"4_0",
                        33=>"4_0", 34=>"4_0", 35=>"4_0", 36=>"4_0", 37=>"4_30", 38=>"5_0",
                        39=>"5_0", 40=>"5_30", 41=>"5_30", 42=>"6", 43=>6,
                        44=>"6_0", 45=>"6_0", 46=>"6_30", 47=>"7_0", 48=>"7_0", 49=>"8_0",
                        50=>"8_0", 51=>"8_0", 52=>"8_0", 53=>"8_0", 54=>"8_0", 55=>"9_0",
                        56=>"9_0", 57=>"9_0", 58=>"9_30", 59=>"9_30", 60=>"10_0",
                        61=>"10_0", 62=>"10_0", 63=>"10_0", 64=>"10_0", 65=>"11_0",
                        66=>"11_0", 67=>"12_0", 68=>"12_0", 69=>"12_0", 70=>"12_0",
                        71=>"13_0", 72=>"13_0")




  AGGREGATION=Hash.[](
      "service_running"=>"sc",
      "operator_name"=>"on",
      "active_subscriptions"=>"asup",
      "total_media_spend"=>"tms",
      "mt_daily_approved"=>"dt",
      "greater_eq_agg_op"=>"$gte",
      "dollar_agg_op"=>"$",
      "live_campaign_count"=>"lcc",
      "sum_agg_op"=>"$sum",
      "group_agg_op"=>"$group",
      "match_agg_op"=>"$match",
      "id_"=>"_id",
      "value_dot"=>".v",
      "content_provider_id"=> "cpid",
      "campaign_id"=> "cid",
      "campaign_name"=> "cn",
      "service_code"=> "sc",
      "acquisition_model"=> "am",
      "country"=> "c",
      "landing_page"=> "lp",
      "keyword"=> "ky",
      "timezone"=> "tz",
      "operator_id"=> "oid",
      "graph_id"=>"gid",
      "gateway_share"=> "gs",
      "operator_share"=> "ops",
      "unit_charge_dollar"=> "ucd",
      "net_charge_dollar"=> "ncd",
      "unit_charge_local"=> "ucl",
      "net_charge_local"=> "ncl",
      "live_operators"=>"lo",
      "live_media"=>"lm",
      "live_operator_count"=>"loc",
      "live_media_count"=>"lmc",
      "currency"=>"cu",
      "exchange"=>"ex",
      "offset"=>"of",
      "date"=> "d",
      "week_of_year"=> "wy",
      "month"=> "m",
      "month_id"=> "mid",
      "year"=> "y",
      "day_of_year"=> "dy",
      "media_id"=> "meid",
      "media_name"=> "mn",
      "media_payout_dollar"=> "mpd",
      "media_payout_local"=> "mpl",
      "impressions"=> "i",
      "duplicate_impressions"=> "di ",
      "unique_impressions"=> "ui",
      "invalid_impressions"=> "ii",
      "valid_impressions"=> "vi",
      "banner_clicks"=> "bc",
      "duplicate_banner_clicks"=> "dbc",
      "unique_banner_clicks"=> "ubc",
      "invalid_banner_clicks"=> "ibc",
      "valid_banner_clicks"=> "vbc",
      "landing_page_views"=> "lpv",
      "duplicate_landing_page_views"=> "dlpv",
      "unique_landing_page_views"=> "ulpv",
      "invalid_landing_page_views"=> "ilpv",
      "valid_landing_page_views"=> "vlpv",
      "engagments"=> "e",
      "duplicate_engagments"=> "de",
      "unique_engagments"=> "ue",
      "invalid_engagments"=> "ie",
      "valid_engagments"=> "ve",
      "subscriptions"=> "sup",
      "new_subscriptions"=>"nsup",
      "un_subscriptions"=> "usup",
      "valid_subscriptions"=> "vsup",
      "invalid_subscriptions"=> "isup",

      "content_views"=> "cv",
      "media_postbacks"=> "mp",
      "subscription_postbacks"=> "sp",
      "subscribers"=> "sub",
      "active_subscribers"=> "asub",
      "new_subscribers"=>"nsub",

      "subscriptions_day_0"=> "sup0",
      "subscriptions_day_1"=> "sup1",
      "subscriptions_day_3"=> "sup3",
      "subscriptions_day_7"=> "sup7",
      "subscriptions_day_15"=> "sup15",

      "un_subscriptions_day_0"=> "usup0",
      "un_subscriptions_day_1"=> "usup1",
      "un_subscriptions_day_3"=> "usup3",
      "un_subscriptions_day_7"=> "usup7",
      "un_subscriptions_day_15"=> "usup15",
      "total_mt_sent"=>"tmts",
      "mt_sent"=> "mts",
      "mt_fail"=> "mtf",
      "mt_success"=> "mtss",
      "mt_unknown"=> "mtu",
      "mt_retry"=> "mtr",
      "mt_request"=>"mtre",
      "mt_sent_by_operator"=> "mtso",
      "mt_delivered"=> "mt",
      "invalid_conversions"=>"ic",


      "media_cost_dollar"=> "mdcd",
      "media_cost_local"=> "mdcl",
      "revenue_dollar"=> "rd",
      "revenue_local"=> "rl",
      "net_revenue_dollar"=> "nrd",
      "net_revenue_local"=> "nrl",
      "total_revenue_dollar"=>"trd",
      "total_net_revenue_dollar"=>"tnrd",
      "cost_per_active_subscriber_dollar"=> "cpasd",
      "cost_per_active_subscriber_local"=> "cpasl",
      "average_revenue_per_subscriber_dollar"=> "arpud",
      "average_revenue_per_subscriber_local"=> "arpul",

      "pause_roi_dollar"=> "proid",
      "pause_roi_local"=> "proil",
      "daily_roi_dollar"=> "droid",
      "daily_roi_local"=> "droil",
      "valid_click_percent"=> "vcp",
      "content_view_percent"=> "cvp",
      "sub_rate_percent"=> "srp",
      "valid_sub_percent"=> "vsp",
      "new_sub_unsub_percent"=> "nsup",
      "unsub_percent"=> "up",
      "valid_engagment_percent"=> "vep",
      "landing_page_valid_percent"=> "lpvp",
      "mt_success_percent"=> "mssp",
      "mt_sent_percent"=> "mtsp"
  )

  Contentprovider=Hash.[](
         0=>"content_provider_id",
         1 => "email",
         2=> "first_name",


  )
  Company_Hash=Hash.[](
      0=>"company_id",
      1 => "email",
      2=> "company_name",

  )

  STATUS_MAP=Hash.[](
      0=>"Inactive",
      1=>"Active",
      2=>"Suspened"
  )





end
