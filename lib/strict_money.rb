require "strict_money/amount"
require "strict_money/version"

# Manipulate money and currency with strictness around currencies and time periods.
module StrictMoney
  # Exception raised when someone uses a currency that is not supported within
  # the application.
  UnsupportedCurrencyError = Class.new(StandardError)
  # Exception raised when someone uses an invalid currency in a method call.
  WrongCurrencyError = Class.new(StandardError)

  def self.reset_supported_currencies
    @supported_currencies = :all
  end

  reset_supported_currencies

  def self.supported_currency?(currency)
    (@supported_currencies == :all) || @supported_currencies.include?(currency)
  end

  def self.supported_currencies
    @supported_currencies
  end

  def self.supported_currencies=(sc)
    @supported_currencies = sc
  end
end
