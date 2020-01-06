RSpec.describe StrictMoney::HistoricalAmount do
  let(:gbp_amount) { StrictMoney::Amount.new(1, 'GBP') }
  let(:usd_amount) { StrictMoney::Amount.new(1, 'USD') }

  it "defines #as_json" do
    subject = described_class.new([gbp_amount, usd_amount])
    expect(subject.as_json).to eq('GBP' => 1, 'USD' => 1)
  end

  describe "when instantiating with the same currency more than once" do
    it "raises an error" do
      expect { described_class.new([gbp_amount, gbp_amount]) }.to \
        raise_error(StrictMoney::HistoricalAmount::RedundantCurrencyError)
    end
  end

  describe "when two HistoricalMoneyAmounts have the same currencies" do
    let(:subject1) { described_class.new([gbp_amount, usd_amount]) }
    let(:subject2) { described_class.new([gbp_amount, usd_amount]) }

    it "allows addition" do
      result = subject1 + subject2
      expect(result.as_float('GBP')).to eq(2)
      expect(result.as_float('USD')).to eq(2)
    end
  end

  describe "when two HistoricalMoneyAmounts have different currencies" do
    let(:subject1) { described_class.new([gbp_amount, usd_amount]) }
    let(:subject2) { described_class.new([usd_amount]) }

    it "does not allow addition" do
      expect { subject1 + subject2 }.to \
        raise_error(StrictMoney::HistoricalAmount::WrongCurrencyError)
    end
  end
end
