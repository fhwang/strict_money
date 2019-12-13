module StrictMoney
  # Store configuration options for StrictMoney overall.
  class Configuration
    attr_reader :supported_currencies

    def initialize
      @supported_currencies = :all
    end

    def supported_currencies=(sc)
      @supported_currencies = sc
    end

    def supported_currency?(currency)
      (@supported_currencies == :all) || @supported_currencies.include?(currency)
    end
  end
end
