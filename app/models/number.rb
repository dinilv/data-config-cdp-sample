class Number

  include Mongoid::Document

  field :value, type: Integer

  attr_reader :value

  def initialize(value)
    @value = value
  end

  def to_f
    @value.to_f
  end

  def to_i
    @value.to_i
  end

  def to_s

    puts "s"
    if (@value.to_i > 100) && (@value.to_i < 1000000)
      return (@value.to_f/1000).round(3), "K"
    elsif (@value.to_i > 1000000) && (@value.to_i < (1000000000))
      return (@value.to_f/1000000).round(3), "M"
    elsif (@value.to_i > 1000000000)
      return (@value.to_i/1000000000).round(3), "B"
    elsif (@value.to_i < 100)
      return value,""
    else
      puts "Value not matched or out of reach"
      return value,""
    end
  end

  def mongoize
    {DbConstants::V=> @value}
  end

  class << self
    def demongoize(object)
      ActiveSupport::NumberHelper.number_to_delimited(object[DbConstants::V])
    end

    def mongoize(object)
      case object
      when Number then object.mongoize
      else object
      end
    end

    def evolve(object)
      object.mongoize
    end

  end
end