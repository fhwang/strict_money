module StrictMoney
  # Initialize StrictMoney inside a Rails application.
  class Railtie < Rails::Railtie
    initializer :strict_money do
      Module.const_defined?(:Mongoid) && \
        require("strict_money/orms/mongoid")
    end
  end
end
