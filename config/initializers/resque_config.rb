module ResqueConfig

	require "resque"
	require 'resque-scheduler'
	require 'resque/scheduler/server'
	Resque.redis = Redis.new(url:"redis://localhost:6379/1")
	Resque.schedule = YAML.load_file(File.join(__dir__, 'resque_schedule.yml'))
end
