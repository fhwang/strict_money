require "strict_money/amount"
require "strict_money/configuration"
require "strict_money/version"
require "strict_money/railtie" if defined?(Rails::Railtie)
require "forwardable"

# Manipulate money and currency with strictness around currencies and time periods.
module StrictMoney
  # Exception raised when someone uses a currency that is not supported within
  # the application.
  UnsupportedCurrencyError = Class.new(StandardError)
  # Exception raised when someone uses an invalid currency in a method call.
  WrongCurrencyError = Class.new(StandardError)

  class << self
    extend Forwardable

    def_delegators :configuration, :supported_currency?, :supported_currencies

    attr_reader :configuration

    def configure
      yield(configuration)
    end

    def reset_configuration
      @configuration = Configuration.new
    end
  end
end

StrictMoney.reset_configuration
