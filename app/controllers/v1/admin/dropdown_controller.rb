class V1::Admin::DropdownController <  ApplicationController
  before_action :authorize, :only => [:campaign_dropdown,:operator_dropdown,:media_dropdown,:currency_symbol]
  def campaign_dropdown
    begin
      campaign_data=[]
      response_array = []
      campaign_ids=ContentProvider.all.pluck(:content_provider_id)
      campaign_ids.each do |content_provider|
        campaign_list =get_campaign_ids(content_provider).split(",")
        campaigns = Campaign.in(:campaign_id=> campaign_list).only(:campaign_id,:campaign_name)
        campaign=Hash.new
        campaigns.each do |key|
          campaign={"id"=>key.campaign_id,"name"=>key.campaign_name}
          campaign_data.push(campaign)
        end
      end

      response = GlobalResponseConstants::SUCCESS.dup
      response[GlobalResponseConstants::DATA] = campaign_data
      render :json => response, :status => response[GlobalResponseConstants::STATUS_CODE]
    rescue Exception => e
      exception_job = {:controller_action => "campaign_get_id_controller", :exception => e.message , :backtrace => e.backtrace.inspect, :version=>"v1"}
      Resque.enqueue(ExceptionLogJob,exception_job)
      response = GlobalResponseConstants::EXCEPTION.dup
      render :json => response, :status => response[GlobalResponseConstants::EXCEPTION]
    end
  end

  def operator_dropdown
    data=@@redis_service.get_hashset_data_all(OPERATORS)
    operator = Hash.new
    db=[]
    data.each do |key,value|
      operator={"id" => key.to_i, "name" => value}
      db.push(operator)
    end
      response = GlobalResponseConstants::SUCCESS.dup
      response[GlobalResponseConstants::DATA] = db
      render :json => response, :status => response[GlobalResponseConstants::STATUS_CODE]
  end

  def media_dropdown
    data=@@redis_service.get_hashset_data_all(MEDIA)
    db=[]
    media_data = Hash.new
    data.each do |key,value|
      media_data={"id" => key.to_i, "name" => value}
      db.push(media_data)
    end
      response = GlobalResponseConstants::SUCCESS.dup
      response[GlobalResponseConstants::DATA] = db
      render :json => response, :status => response[GlobalResponseConstants::STATUS_CODE]
  end

def currency_symbol
  set_currency_symbol
  db=[]
  data=RedisConfig.getConnection.hgetall('currency_symbol')
  currency_data= Hash.new
  data.each do |key,value|
    currency_data ={"id"=>key.to_i,"currency_symbol"=>value}
    db.push(current_data)
  end
  response = GlobalResponseConstants::SUCCESS.dup
  response[GlobalResponseConstants::DATA] = db
  render :json => response, :status => response[GlobalResponseConstants::STATUS_CODE]
end
  def time_zone
    data=[]
  end

end