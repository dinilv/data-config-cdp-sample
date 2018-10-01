class Redis::RedisDaoService
  include ConfigConstants

  def key_exists(key)
    RedisConfig.getConnection.exists(key)
  end

  def flush_db
    RedisConfig.getConnection.flushdb
  end

  def set_unique_set(key,set)
    RedisConfig.getConnection.sadd(key, set)
  end

  def get_unique_set(set)
    RedisConfig.getConnection.smembers(set)
  end

  def set_sorted_set(set,key,score)
    RedisConfig.getConnection.zadd(set,score,key,)
  end

  def get_sorted_set(set)
    RedisConfig.getConnection.zrange(set,0,-1)
  end

  def del_key(key)
    RedisConfig.getConnection.del(key)
  end
  def set_hashset(key,field,hash_set)
    RedisConfig.getConnection.hset(key,field, hash_set)
  end

  def get_hashset_data(key,field)
    RedisConfig.getConnection.hget(key, field)
  end

  def get_hashset_data_all(key)
    RedisConfig.getConnection.hgetall(key)
  end

  def set_json_data(key,json_data)
    RedisConfig.getConnection.set(key, json_data)
  end
  def get_json_data(key)
    RedisConfig.getConnection.get(key)
  end

  def token_exist(token)
    RedisConfig.getConnection.exists(token)
  end




end