class ExceptionLogJob
    @queue = :exception_queue
    def self.perform(exception)
      ExceptionLog.new(exception).save
    end
end
