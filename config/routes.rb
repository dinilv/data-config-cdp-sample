Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  match '/content_provider/signup' => 'v1/content_providers/content_provider#create', via: [:post]
  match '/content_provider/list/' => 'v1/content_providers/content_provider#list', via: [:get]
  match '/content_provider/update/:id' => 'v1/content_providers/content_provider#update', via: [:put]
  match '/content_provider/dashboard/:id' => 'v1/content_providers/content_provider#dashboard', via: [:get]
  match '/content_provider/report/upload' => 'v1/imports/report#upload_csv', via: [:post]
  match '/content_provider/show/:id' => 'v1/content_providers/content_provider#show', via: [:get]


  #company
  match '/company/signup' => 'v1/admin/company#create', via: [:post]
  match '/company/list/' => 'v1/admin/company#list', via: [:get]
  match '/content_provider/update/:id' => 'v1/content_providers/content_provider#update', via: [:put]
  match '/content_provider/dashboard/:id' => 'v1/content_providers/content_provider#dashboard', via: [:get]
  match '/content_provider/report/upload' => 'v1/imports/report#upload_csv', via: [:post]


  match '/campaign/create' => 'v1/campaigns/campaign#create', via: [:post]
  match '/campaigns' => 'v1/campaigns/campaign#index', via: [:get]
  match '/campaign/update' => 'v1/campaigns/campaign#update', via: [:put]
  match '/campaign/list' => 'v1/campaigns/campaign#index', via: [:get]
  match '/campaign/show/:id' => 'v1/campaigns/campaign#show', via: [:get]
  match '/campaign/get_id' => 'v1/campaigns/campaign#get_id', via: [:get]


  match '/operator/create' => 'v1/operators/operator#create_operator', via: [:post]
  match '/operator/operators' => 'v1/operators/operator#list_operator', via: [:get]
  match '/operator/update' => 'v1/operators/operator#update_operator', via: [:put]
  match '/operator/show/:id' => 'v1/operators/operator#show', via: [:get]


  #nis_dropdown
  match '/operator/nis/dropdown' => 'v1/operators/operator#nis_operator_dropdown', via: [:get]

  match '/campaign/dropdown' => 'v1/admin/dropdown#campaign_dropdown', via: [:get]
  match '/operator/dropdown' => 'v1/admin/dropdown#operator_dropdown', via: [:get]
  match '/currency/symbol'   => 'v1/admin/dropdown#currency_symbol', via: [:get]

  #migration
  match '/migration/advertiser' => 'v1/migration/api_migration#advertiser', via: [:post]
  match '/migration/media' => 'v1/migration/api_migration#media', via: [:post]
  match '/migration/campaign' => 'v1/migration/api_migration#campaign_create', via: [:post]


  match '/admin/addmedia' => 'v1/admin/admin#create_media', via: [:post]
  match '/admin/medias' => 'v1/admin/admin#list_media', via: [:get]
  match '/media/update' => 'v1/admin/admin#update_media', via: [:put]
  match '/admin/validate_email' => 'v1/admin/admin#validate_email', via: [:get]
  match '/media/show/:id' => 'v1/admin/admin#show_media', via: [:get]
  match '/media/dropdown' => 'v1/admin/dropdown#media_dropdown', via: [:get]


  match '/auth/reset-password' => 'v1/authentication/authentication#reset_password', via: [:post]
  match '/auth/forgot-password' => 'v1/authentication/authentication#forgot_password', via: [:post]
  match '/auth/verify' => 'v1/authentication/authentication#verify', via: [:get]
  match '/auth/login' => 'v1/authentication/authentication#log_in', via: [:post]
  match '/update_password' => 'v1/authentication/authentication#update_password', via: [:put]

  #dashboard analytics
  match '/analytics/dashboard/graph' => 'v1/analytics/dashboard#graph', via: [:get]
  match '/analytics/dashboard/lifetime' =>'v1/analytics/dashboard#lifetime', via: [:get]
  match '/analytics/dashboard/current' =>'v1/analytics/dashboard#current', via: [:get]
  match '/analytics/dashboard/active' =>'v1/analytics/dashboard#active', via: [:get]

  #campaign analytics
  match '/analytics/campaign/list' => 'v1/analytics/campaign#list', via: [:get]
  match '/analytics/campaign/details'=> 'v1/analytics/campaign#details', via: [:get]
  match '/analytics/campaign/current' =>'v1/analytics/campaign#current', via: [:get]
  match '/analytics/campaign/graph' => 'v1/analytics/campaign#graph', via: [:get]
  match '/analytics/campaign/media' => 'v1/analytics/campaign#media', via: [:get]
  match '/analytics/campaign/operator' => 'v1/analytics/campaign#operator', via: [:get]
  match '/analytics/campaign/media/stats' => 'v1/analytics/campaign#media_stats', via: [:get]
  match '/analytics/campaign/stats' =>'v1/analytics/campaign#campaign_stats', via: [:get]

  #view report
  match '/reports/campaign/traffic' => 'v1/analytics/view_report#campaign_traffic', via: [:get]
  match '/reports/campaign/monetize' => 'v1/analytics/view_report#campaign_monetize', via: [:get]
  match '/reports/media/monetize' => 'v1/analytics/view_report#media_monetize', via: [:get]
  match '/reports/operator/monetize' => 'v1/analytics/view_report#operator_monetize', via: [:get]
  match '/reports/msisdn/monetize' => 'v1/analytics/view_report#msisdn', via: [:get]

  #download report
  match '/download/campaign/traffic' => 'v1/analytics/download_report#campaign_traffic', via: [:get]
  match '/download/campaign/monetize' => 'v1/analytics/download_report#campaign_monetize', via: [:get]
  match '/download/media/monetize' => 'v1/analytics/download_report#media_monetize', via: [:get]
  match '/download/operator/monetize' => 'v1/analytics/download_report#operator_monetize', via: [:get]
  match '/download/msisdn/monetize' => 'v1/analytics/download_report#msisdn', via: [:get]

  #custom report
  match '/reports/custom/view' => 'v1/analytics/custom_report#view', via: [:get]
  match '/reports/custom/download' => 'v1/analytics/custom_report#download', via: [:get]

  #testing
  match '/test/assigner/lifetime' => 'test/job_test#testlifetime', via: [:get]
  match '/test/assigner/account' => 'test/job_test#testaccount', via: [:get]
  match '/test/campaign/job' => 'test/job_test#add_default_data', via: [:get]
  match '/test/zero' => 'test/job_test#zero_data_job', via: [:get]
  match '/test/delete' => 'test/job_test#delete_job', via: [:get]
  #migration
  match '/migrate/cp/curency' => 'migration/db#create_cp_currecny', via: [:get]
  match '/migrate/campaign/details' => 'migration/db#campaign_details', via: [:get]
  match '/migrate/campaign/media' => 'migration/db#campaign_media', via: [:get]
  match '/migrate/operator' => 'migration/db#operator_data', via: [:get]
  match '/migrate/media' => 'migration/db#media_data', via: [:get]
  match '/migrate/all' => 'migration/db#all_migration',via: [:get]
  #logs
  match '/admin/exception' => 'v1/admin/log#exception_list',via: [:get]



  mount Resque::Server.new, :at => "/resque-cmp"
end
