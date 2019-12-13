require "strict_money/orms/mongoid/amount"
require "strict_money/orms/mongoid/configuration"
require "strict_money/orms/mongoid/financiality_validator"

class << StrictMoney
  def_delegators :configuration, :demongoize_amount
end
