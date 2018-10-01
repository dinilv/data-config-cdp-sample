class DateUtility

	def self.getUtcStartDateFromCurrent(days)
		'''
		Function to get prev days
		'''
		prevDate = Time.at(Time.now.utc.to_i - 86400 * days).utc
		puts prevDate
		utcDate  = Time.utc(prevDate.year, prevDate.month, prevDate.day)
		return utcDate
	end

	def self.getUtcEndDateFromCurrent(days)
		'''
		Function to get prev days
		'''
		prevDate = Time.at(Time.now.utc.to_i - 86400 * days).utc
		utcDate  = Time.utc(prevDate.year, prevDate.month, prevDate.day,23 ,0,0)
		return utcDate
	end

	def self.getUtcStartHourFromCurrent(hours)
		'''
		Function to get prev days
		'''
		prevDate = Time.at(Time.now.utc.to_i - 3600 * hours).utc
		utcDate  = Time.utc(prevDate.year, prevDate.month, prevDate.day,prevDate.hour,0,0)
		return utcDate
	end

	def self.getStartUtcDateFromDateAndHours(date,hours)
		utcDate  = Time.utc(date.year, date.month, date.day,0,0,0)
		customDate = Time.at(utcDate.to_i + (3600 * hours)).utc
		reqDate  = Time.utc(customDate.year, customDate.month, customDate.day,customDate.hour,0,0)
		return reqDate
	end
	def self.getEndUtcDateFromDateAndHours(date,hours)
		utcDate  = Time.utc(date.year, date.month, date.day,23,0,0)
		customDate = Time.at(utcDate.to_i + (3600 * hours)).utc
		reqDate  = Time.utc(customDate.year, customDate.month, customDate.day,customDate.hour,0,0)
		return reqDate
	end

	def self.getUtcEndHourFromCurrent(hours)
		'''
		Function to get prev days
		'''
		prevDate = Time.at(Time.now.utc.to_i - 3600 * hours).utc
		utcDate  = Time.utc(prevDate.year, prevDate.month, prevDate.day,prevDate.hour,59,0)
		return utcDate
	end

	def self.getUtcStartDateFromDate(date)
		'''
		Function to get prev days
		'''
		utcDate  = Time.utc(date.year, date.month, date.day,0,0,0)
		return utcDate
	end

	def self.getUtcEndDateFromDate(date)
		'''
		Function to get prev days
		'''
		utcDate  = Time.utc(date.year, date.month, date.day,23,45,0)
		return utcDate
	end

	def self.getUtcStartDateFromDateAndDays(date,days)
		utcDate  = Time.utc(date.year, date.month, date.day,0,0,0)
		prevDate = Time.at(utcDate.to_i - 86400 * days).utc
		newDate  = Time.utc(prevDate.year, prevDate.month, prevDate.day)
		return newDate
	end

	def self.getUtcEndDateFromDateAndDays(date,days)
		utcDate  = Time.utc(date.year, date.month, date.day,23,45,0)
		prevDate = Time.at(utcDate.to_i - 86400 * days).utc
		newDate  = Time.utc(prevDate.year, prevDate.month, prevDate.day)
		return newDate
	end

	#for handling different timezones
	def self.getUtcDateByHourMinute(minute,hour,date)
		Time.utc(date.year, date.month, date.day,hour,minute,0)
	end
	def self.getForwardUtcDateByHourMinute(minute,hour,date)
    nextDay=Time.at(date.to_i + 86400).utc
		Time.utc(nextDay.year, nextDay.month, nextDay.day,hour,minute,0)
	end

	def self.getBackwardSatrtUtcDateByHourMinute(minute,hour,date)
    prevDay=Time.at(date.to_i - 86400).utc
    Time.utc(prevDay.year, prevDay.month, prevDay.day,(23-hour),(59-minute),0)
	end

  def self.getBackwardEndUtcDateByHourMinute(minute,hour,date)
    Time.utc(date.year, date.month, date.day,(23-hour),(59-minute),0)
  end

  def self.getDateScore(recv_date)
    date=recv_date.to_date
    utcDate  = Time.utc(date.year, date.month, date.day,0,0,0)
    now =Time.now.utc
    score=100-((now -utcDate)/1.day).round
    return score
  end
end
