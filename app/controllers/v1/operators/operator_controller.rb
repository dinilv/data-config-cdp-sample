class V1::Operators::OperatorController < ApplicationController

  def create_operator
    begin
      unless  params.has_key?(:operator_name) && params.has_key?(:operator_country)
        response = GlobalResponseConstants::NOT_ACCEPTABLE.dup
        render :json => response, :status => response[GlobalResponseConstants::STATUS_CODE]
      else
        status,message = @@operator_service.create_operator(params)
        unless status
          response = GlobalResponseConstants::EXCEPTION.dup
          render :json => response, :status => response[GlobalResponseConstants::STATUS_CODE]
        else
          response = GlobalResponseConstants::SUCCESS.dup
          render :json => response, :status => response[GlobalResponseConstants::STATUS_CODE]
        end
      end
    rescue Exception => e
      puts "Admin operator creation Exception = #{e}"
      exception_job = {:controller_action => "admin_create_operation_controller", :exception => e.message, :backtrace => e.backtrace.inspect, :version=>"v1"}
      Resque.enqueue(ExceptionLogJob,exception_job)
      response = GlobalResponseConstants::EXCEPTION.dup
      render :json => response, :status => response[GlobalResponseConstants::STATUS_CODE]
    end
  end

  def update_operator
    begin
      unless  params.has_key?(:operator_id)
        response = GlobalResponseConstants::NOT_ACCEPTABLE.dup
        render :json => response, :status => response[GlobalResponseConstants::STATUS_CODE]
      else
        status,message = @@operator_service.update_operator(params)
        unless status
          response = GlobalResponseConstants::EXCEPTION.dup
          render :json => response, :status => response[GlobalResponseConstants::STATUS_CODE]
        else
          response = GlobalResponseConstants::SUCCESS.dup
          render :json => response, :status => response[GlobalResponseConstants::STATUS_CODE]
        end
      end
    rescue Exception => e
      puts "Admin operator update Exception = #{e}"
      exception_job = {:controller_action => "admin_update_operator_controller", :exception => e.message, :backtrace => e.backtrace.inspect, :version=>"v1"}
      Resque.enqueue(ExceptionLogJob,exception_job)
      response = GlobalResponseConstants::EXCEPTION.dup
      render :json => response, :status => response[GlobalResponseConstants::STATUS_CODE]
    end
  end

  def list_operator
    if params['offset']
      offset=params['offset']
    end
    if params['limit']
      limit=params['limit']
    end
    begin
      offset=limit.to_i*(offset.to_i-1)
      operators = Operator.all.skip(offset).limit(limit)
      count=operators.count
      response = GlobalResponseConstants::SUCCESS.dup
      response[GlobalResponseConstants::DATA] = operators
      response[GlobalResponseConstants::TOTAL_COUNT]=count
      render :json => response, :status => response[GlobalResponseConstants::STATUS_CODE]
    rescue Exception => e
      puts "Admin operator listing Exception = #{e}"
      exception_job = {:controller_action => "admin_listing_operator_controller", :exception => e.message, :backtrace => e.backtrace.inspect, :version=>"v1"}
      Resque.enqueue(ExceptionLogJob,exception_job)
      response = GlobalResponseConstants::EXCEPTION.dup
      render :json => response, :status => response[GlobalResponseConstants::STATUS_CODE]
    end
  end

  def show
    begin
      status, data = @@operator_service.show_operator(params)
      if status
        response = GlobalResponseConstants::SUCCESS.dup
        response[GlobalResponseConstants::DATA] = data
        render :json => response, :status => response[GlobalResponseConstants::STATUS_CODE]
      elsif !status && data == "exception"
        response = GlobalResponseConstants::EXCEPTION.dup
        render :json => response, :status => response[GlobalResponseConstants::STATUS_CODE]
      else
        response = GlobalResponseConstants::REQUEST_INVALID.dup
        response[GlobalResponseConstants::MESSAGE] = data
        render :json => response, :status => response[GlobalResponseConstants::STATUS_CODE]
      end
    rescue Exception => e
      puts "Operator show = #{e}"
      exception_job = {:controller_action => "operator_show", :exception => e.message , :backtrace => e.backtrace.inspect, :version=>"v1"}
      Resque.enqueue(ExceptionLogJob,exception_job)
      response = GlobalResponseConstants::EXCEPTION.dup
      render :json => response, :status => response[GlobalResponseConstants::EXCEPTION]
    end
  end

  def nis_operator_dropdown

    data= @@redis_service.get_all_operator
    operator = Hash.new( "operator" )
    db=[]
    data.each do |key,value|
      operator={"operator_id" => key, "operator_name" => value}
      db.push(operator)
    end
    if data
      response = GlobalResponseConstants::SUCCESS.dup
      response[GlobalResponseConstants::DATA] = db
      render :json => response, :status => response[GlobalResponseConstants::STATUS_CODE]
    end


  end



end
