RSpec.describe StrictMoney::Orms::Mongoid::Amount do
  describe "#mongoize" do
    it "includes amount and currency" do
      amount = StrictMoney::Amount.new(123, 'USD')
      expect(amount.mongoize).to eq('currency' => 'USD', 'amount' => 123)
    end

    it "preserves sub-cent precision" do
      amount = StrictMoney::Amount.new(123.4567, 'USD')
      expect(amount.mongoize).to eq('currency' => 'USD', 'amount' => 123.4567)
    end
  end

  describe ".demongoize" do
    it "reads amount and currency" do
      amount = StrictMoney::Amount.demongoize(
        'currency' => 'USD', 'amount' => 123
      )
      expect(amount.currency).to eq('USD')
      expect(amount.as_float('USD')).to eq(123)
    end
  end

  describe ".demongoize with a global config" do
    before do
      StrictMoney.configure do |config|
        config.demongoize_amount do |object|
          amount = object['amount']
          amount ||= object['fractional'] / 100
          StrictMoney::Amount.new(amount, object['currency'])
        end
      end
    end

    after do
      StrictMoney.reset_configuration
    end

    it "allows custom demongoization" do
      amount1 = StrictMoney::Amount.demongoize(
        'currency' => 'USD', 'amount' => 123
      )
      expect(amount1.currency).to eq('USD')
      expect(amount1.as_float('USD')).to eq(123)
      amount2 = StrictMoney::Amount.demongoize(
        'currency' => 'USD', 'fractional' => 1.51
      )
      expect(amount2.currency).to eq('USD')
      expect(amount2.as_float('USD')).to eq(0.0151)
    end
  end

  it "saves and loads correctly" do
    product = MongoidProduct.new(
      price: StrictMoney::Amount.new(100, 'USD'),
      discount: StrictMoney::Amount.new(0.0111, 'USD')
    )
    product.save!
    prime = MongoidProduct.find(product.id)
    expect(prime.price.as_float('USD')).to eq(100)
    expect(prime.discount.as_float('USD')).to eq(0.0111)
  end

  it "allows nil values" do
    product = MongoidProduct.new(price: StrictMoney::Amount.new(100, 'USD'))
    expect(product).to be_valid
    product.save!
  end
end
