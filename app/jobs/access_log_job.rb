class AccessLogJob
    @queue = :access_log
    def self.perform(access)
        Authentication::AccessLog.new(access).save
    end
end
