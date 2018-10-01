class ApiUtility

  include ApiConstants

  def self.find_factor(value)
    float_value=value.to_f
    if (float_value >= 100.000) && (float_value < 1000.000)
      return  TEN
    elsif (float_value >= 1000.000) && (float_value < 10000.000)
      return  HUNDRED
    elsif (float_value >= 10000.000) && (float_value < 100000.000)
      return  K
    elsif (float_value >= 100000.000) && (float_value < 1000000.000)
      return TEN_K
    elsif (float_value >= 1000000.000) && (float_value < 10000000.000)
      return HUNDRED_K
    elsif (float_value >= 10000000.000) && (float_value < 100000000.000)
      return MILLION
    elsif (float_value >= 100000000.000) && (float_value < 1000000000.000)
      return TEN_MILLION
    elsif (float_value >= 1000000000.000) && (float_value < 10000000000.000)
      return HUNDRED_MILLION
    elsif (float_value >= 10000000000.000) && (float_value < 100000000000.000)
      return BILLION
    else
      return ONE
    end
  end


  def self.format_value(factor,value)
    float_value=value.to_f
    case factor
    when ONE
      return float_value.round(3)
    when TEN
      return (float_value/10.000).round(3)
    when HUNDRED
      return (float_value/100.000).round(3)
    when K
      return (float_value/1000.000).round(3)
    when TEN_K
      return (float_value/10000.000).round(3)
    when HUNDRED_K
      return (float_value/100000.000).round(3)
    when MILLION
      return (float_value/1000000.000).round(3)
    when TEN_MILLION
      return (float_value/10000000.000).round(3)
    when HUNDRED_M
      return (float_value/100000000.000).round(3)
    when BILLION
      return (float_value/1000000000.000).round(3)
    else
      puts "Value not matched or out of reach"
      return float_value
    end

  end

  def self.find_graph_axis_value(factor,value)
    float_value=format_value(factor,value)
   if float_value <=10.00
     return 10
   elsif (float_value >10.00) && (float_value <= 20.00)
     return 20
   elsif (float_value >20.00) && (float_value <= 30.00)
     return 30
   elsif (float_value >30.00) && (float_value <= 40.00)
     return 40
   elsif (float_value >40.00) && (float_value <= 50.00)
     return 50
   elsif (float_value >50.00) && (float_value <= 60.00)
     return 60
   elsif (float_value >60.00) && (float_value <= 70.00)
     return 70
   elsif (float_value >70.00) && (float_value <= 80.00)
     return 80
   elsif (float_value >80.00) && (float_value <= 90.00)
     return 90
   else
     return 100
   end
  end

end