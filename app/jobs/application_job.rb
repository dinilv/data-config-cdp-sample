class ApplicationJob

  require 'open-uri'
  require 'json'
  require 'net/http'
  require "mongo"

  include ConfigConstants
  include ReportImportConstants
  include DbConstants
  include AggregationConstants
  include ApiConstants

  #services
  @@redis_service=Redis::RedisDaoService.new
  @@stat_service=Analytics::StatService.new
  @@config_service=Analytics::ConfigService.new
  @@report_service=Analytics::ReportService.new

  #loggers
  @@logger_import = Logger.new 'log/resque_import.log'
  @@logger_delegator = Logger.new 'log/resque_delegator.log'
  @@logger_aggregator = Logger.new 'log/resque_aggregator.log'
  @@logger_consolidator = Logger.new 'log/resque_consolidator.log'

end
