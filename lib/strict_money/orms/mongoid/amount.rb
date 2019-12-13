module StrictMoney
  module Orms
    module Mongoid
      # Extend StrictMoney::Amount to work with Mongoid.
      module Amount
        def mongoize
          {'currency' => @currency, 'amount' => @amount}
        end

        def self.included(base)
          def base.demongoize(object)
            StrictMoney.demongoize_amount(object)
          end
        end
      end
    end
  end
end

StrictMoney::Amount.include(StrictMoney::Orms::Mongoid::Amount)
