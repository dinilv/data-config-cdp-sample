class TokenRenewJob < ApplicationJob
  @queue = :token_renew_queue
  @@redis_service=Redis::RedisDaoService.new
  begin

  def self.perform
    @@logger.info("in performance")
    active_tokens =RedisConfig.getConnection.lrange("active_token", 0, -1)
    @@redis_service.del_token_list
    active_tokens.each do |key|
      @@redis_service.set_expire(key)
      @@logger.info(key)
    end

  end
    end
end

