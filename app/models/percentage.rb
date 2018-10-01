class Percentage
  include Mongoid::Document

  field :value, type: Float

  attr_reader :value

  def initialize(value)
    @value = value
  end

  def mongoize
    {DbConstants::V=> @value}
  end

  def to_f
    @value.to_f
  end

  class << self
    def demongoize(object)
      ActiveSupport::NumberHelper.number_to_percentage(object[DbConstants::VALUE].to_f,precision: 2)
    end

    def mongoize(object)
      case object
      when Percentage then object.mongoize
      else object
      end
    end

    def evolve(object)
      object.mongoize
    end

  end
end

