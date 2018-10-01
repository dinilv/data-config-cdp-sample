require 'rubygems'
require 'redis'

options = {
  :timeout     => 120,
  :thread_safe => true
}

host = ENV["REDIS_HOST"] || 'localhost'
port = ENV["REDIS_PORT"] || 6379
db   = ENV["REDIS_DB"]   || 5

options.merge!({ :host => host, :port => port, :db => db })

$redis_cache = Redis.new(options)
