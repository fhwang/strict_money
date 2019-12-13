require "bundler/setup"
require "mongoid"
require "strict_money"
require "strict_money/orms/mongoid"

Dir.entries(File.expand_path("../support", __FILE__)).each do |file|
  require "support/#{file}" if file =~ /\.rb$/
end

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
