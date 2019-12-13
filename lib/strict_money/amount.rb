require 'forwardable'

module StrictMoney
  # A value object to describe an single amount of money with a single
  # currency.
  class Amount
    include Comparable
    extend Forwardable

    attr_reader :currency

    def initialize(amount, currency)
      raise IncompleteError unless amount && currency
      raise StrictMoney::UnsupportedCurrencyError unless StrictMoney.supported_currency?(currency)
      @amount = amount
      @currency = currency.upcase
    end

    def -@
      Amount.new(-@amount, @currency)
    end

    def <=>(other)
      return unless other.is_a?(Amount) && currency == other.currency

      as_float(currency) <=> other.as_float(currency)
    end

    def +(addend)
      raise TypeError unless addend.is_a?(Amount)
      Amount.new(as_float(currency) + addend.as_float(currency), currency)
    end

    def -(subtrahend)
      raise TypeError unless subtrahend.is_a?(Amount)
      self + (subtrahend * -1)
    end

    def *(multiplier)
      Amount.new(@amount * multiplier, currency)
    end

    def /(divisor)
      if divisor.is_a?(Amount)
        @amount / divisor.as_float(@currency)
      else
        Amount.new(@amount / divisor, @currency)
      end
    end

    def as_float(currency)
      raise WrongCurrencyError unless currency.upcase == @currency
      @amount.to_f
    end

    def negative?
      as_float(@currency) < 0
    end

    def positive?
      as_float(@currency) > 0
    end

    def round(precision)
      Amount.new(@amount.round(precision), @currency)
    end

    # Exception raised when somebody tries to instantiate an Amount with
    # incomplete information.
    IncompleteError = Class.new(StandardError)
  end
end
