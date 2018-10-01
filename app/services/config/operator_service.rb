class Config::OperatorService < ApplicationService



  def create_operator(operator_data)
    operator = Operator.new
    operator.operator_name = operator_data[:operator_name]
    operator.operator_key = operator_data[:operator_key]
    operator.operator_country = operator_data[:operator_country]
    operator.save
    @@redis_service.set_hashset(OPERATORS, operator.operator_id, operator.operator_name)
    operator_sync_detail = {}
    operator_sync_detail['operator_id'] = operator.operator_id
    operator_sync_detail['operator_key'] = operator.operator_key
    @@operator_sync.operator_sync(operator_sync_detail)
    return true, "success"
  end

  def update_operator(operator_data)
    operator = Operator.find_by(operator_id: operator_data[ConfigConstants::OPERATOR_ID])
    ConfigConstants::Operator_key.each do |key, value|
      operator_value = {}
      operator_value[value] = operator_data[value]
      operator.update_attributes(operator_value)
    end
    @@redis_service.set_operator_data(operator_data[ConfigConstants::OPERATOR_ID])
    operator_sync_detail = {}
    operator_sync_detail['operator_id'] = ConfigConstants::OPERATOR_ID
    operator_sync_detail['operator_key'] = ConfigConstants::OPERATOR_KEY
    @@operator_sync.operator_sync(operator_sync_detail)
    return true, "success"

  end

  def show_operator(operator_data)

    operator_details = Operator.find_by(operator_id: operator_data[:id])
    response_obj = operator_details
    return true, response_obj

  end


end