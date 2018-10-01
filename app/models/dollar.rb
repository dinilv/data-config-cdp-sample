class Dollar
    include Mongoid::Document

    field :value, as: :v, type: BigDecimal

    attr_reader :value

    def initialize(value)
      @value =  value
    end

    def mongoize
      {DbConstants::V=> @value}
    end

    def to_f
      @value.to_f
    end


    class << self
      def demongoize(object)
        ActiveSupport::NumberHelper.number_to_currency( object[DbConstants::V])
      end

      def mongoize(object)
        case object
        when Dollar then object.mongoize
        else object
        end
      end

      def evolve(object)
        object.mongoize
      end

    end
end
