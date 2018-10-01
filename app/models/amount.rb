class Amount
    include Mongoid::Document

    field :currency,as: :c, type: String
    field :value, as: :v, type: BigDecimal

    attr_reader :currency, :value

    def initialize(currency, value)
      @currency, @value = currency, value
    end

    def to_f
      @value.to_f
    end

    def to_s
      ActiveSupport::NumberHelper.number_to_currency(@value,unit: @currency)
    end

    def mongoize
      {DbConstants::C=>@currency,DbConstants::V=> value}
    end

    class << self
      def demongoize(object)
         ActiveSupport::NumberHelper.number_to_currency(object[DbConstants::V],unit: object[DbConstants::C])
      end

      def mongoize(object)
        case object
        when Amount then object.mongoize
        else object
        end
      end

      def evolve(object)
        object.mongoize
      end

    end
end
