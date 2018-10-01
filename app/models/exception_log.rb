class ExceptionLog

  include Mongoid::Document
  include Mongoid::Timestamps

  field :action, type: String
  field :exception, type: String
  field :backtrace, type: String
  field :version,type: String
  field :controller_action,type: String

  def self.listing(search,order)
    results={}
    results=where("version"=>"v1","$or" =>[ {:action => search}]).
        only(["action","exception","backtrace","version"]).limit(10)
    return results
    end


end
