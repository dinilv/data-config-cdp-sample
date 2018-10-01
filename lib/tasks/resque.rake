require 'resque/tasks'
require 'resque-scheduler'
require 'resque/scheduler/server'
require 'resque/scheduler/tasks'

task "resque:setup" => :environment do
  ENV['QUEUE'] = '*'
  ENV['COUNT'] = '5'
  require 'resque'
  require 'resque-scheduler'
end