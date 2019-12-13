module StrictMoney
  module Orms
    module Mongoid
      # Extend StrictMoney::Configuration to work with Mongoid.
      module Configuration
        def demongoize_amount(object = nil, &block)
          if block
            @demongoize_block = block
          elsif @demongoize_block
            @demongoize_block.call(object)
          else
            StrictMoney::Amount.new(object['amount'], object['currency'])
          end
        end
      end
    end
  end
end

StrictMoney::Configuration.include(StrictMoney::Orms::Mongoid::Configuration)
