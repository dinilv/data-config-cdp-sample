module RedisConfig
	
	require "redis"

	@@redis = Redis.new

	def self.getConnection
		return @@redis
	end

end