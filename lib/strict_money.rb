require "strict_money/amount"
require "strict_money/version"

# Manipulate money and currency with strictness around currencies and time periods.
module StrictMoney
  # Exception raised when someone uses an invalid currency in a method call.
  WrongCurrencyError = Class.new(StandardError)
end
