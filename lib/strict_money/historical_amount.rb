module StrictMoney
  # A value object to describe one or more money amounts at a point in time
  # when the exchange rate was known.
  class HistoricalAmount
    def self.zero(*currencies)
      new(currencies.uniq.map { |currency| Amount.new(0, currency) })
    end

    def initialize(amounts)
      @amounts = amounts
      if currencies != currencies.uniq
        raise RedundantCurrencyError, currencies
      end
    end

    [:-@, :*, :/, :round].each do |operator|
      define_method(operator) do |*args|
        new_amounts = @amounts.map { |amount|
          amount.send(operator, *args)
        }
        self.class.new(new_amounts)
      end
    end

    def <=>(other)
      if other.is_a?(HistoricalAmount) && currencies == other.currencies
        currency = currencies.first
        as_float(currency) <=> other.as_float(currency)
      end
    end

    def +(addend)
      raise WrongCurrencyError unless addend.currencies == currencies
      new_amounts = @amounts.map { |amount|
        amount + addend.amount(amount.currency)
      }
      self.class.new(new_amounts)
    end

    def as_float(currency)
      amount(currency).as_float(currency)
    end

    def as_json(_options = nil)
      currencies.each_with_object({}) { |currency, result|
        result[currency] = amount(currency).as_float(currency)
      }
    end

    def currencies
      @amounts.map(&:currency).sort
    end

    def amount(currency)
      @amounts.detect { |amount| amount.currency == currency }
    end

    def positive?
      @amounts.all?(&:positive?)
    end

    # Raised when HistoricalAmount is instantiated with more than one amount of
    # a given currency.
    RedundantCurrencyError = Class.new(StandardError)

    # Raised when an method is called with another historical amount whose
    # currencies are not the same.
    WrongCurrencyError = Class.new(StandardError)
  end
end
