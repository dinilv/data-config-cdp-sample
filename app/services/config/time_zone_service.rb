class Config::TimeZoneService
  include ConfigConstants
  def self.get_local_time(timezone_id)
    offset=TIME_OFFSET[timezone_id]
    time_now=(Time.now.utc + (3600*offset))
    return time_now.strftime('%H_%M').to_s
  end

end