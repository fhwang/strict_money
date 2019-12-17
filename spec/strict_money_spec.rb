RSpec.describe StrictMoney do
  after do
    StrictMoney.reset_configuration
  end

  it "allows global currency configuration" do
    StrictMoney.configure do |config|
      config.supported_currencies = %w(USD GBP)
    end
    expect(StrictMoney.supported_currencies).to eq(%w(USD GBP))
  end
end
