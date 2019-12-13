RSpec.describe StrictMoney::Amount do
  it "defines the #currency getter but not the setter" do
    subject = described_class.new(10, 'USD')
    expect(subject.currency).to eq('USD')
    expect { subject.currency = 'GBP' }.to raise_error(NoMethodError)
  end

  it "does not define setters or getters for #amount" do
    subject = described_class.new(10, 'USD')
    expect { subject.amount }.to raise_error(NoMethodError)
    expect { subject.amount = 2 }.to raise_error(NoMethodError)
  end

  it "does not allow #as_float without an argument" do
    subject = described_class.new(10, 'USD')
    expect { subject.as_float }.to raise_error(ArgumentError)
  end

  it "allows #as_float('USD') if the currency is already the same" do
    subject = described_class.new(12.3, 'USD')
    expect(subject.as_float('USD')).to eq(12.3)
  end

  it "allows instantiation with 'usd'" do
    subject = described_class.new(12.3, 'usd')
    expect(subject.currency).to eq('USD')
  end

  it "allows #as_float('usd')" do
    subject = described_class.new(12.3, 'USD')
    expect(subject.as_float('usd')).to eq(12.3)
  end

  it "does not allow #as_float to convert to a different currency" do
    subject = described_class.new(12.3, 'USD')
    expect { subject.as_float('GBP') }.to \
      raise_error(StrictMoney::WrongCurrencyError)
  end

  it "does not allow instantiation if either amount or currency is undefined" do
    expect {
      described_class.new(12.34, nil)
    }.to raise_error(StrictMoney::Amount::IncompleteError)
    expect {
      described_class.new(nil, 'USD')
    }.to raise_error(StrictMoney::Amount::IncompleteError)
  end

  it "automatically casts string values to numbers" do
    money1 = described_class.new("1.5", 'USD')
    expect(money1.as_float('USD')).to eq(1.5)
  end

  it "defines #negative?" do
    expect(described_class.new(1000, 'USD').negative?).to be_falsy
    expect(described_class.new(-1000, 'USD').negative?).to be_truthy
  end

  it "preserves sub-cent precision in-Ruby" do
    subject = described_class.new(0.0151, 'USD')
    expect(subject.as_float('USD')).to eq(0.0151)
  end

  it "can be divided and multiplied without specifying the currency" do
    subject = described_class.new(2.5, 'USD')
    multiplied = subject * 5
    expect(multiplied.as_float('USD')).to eq(12.5)
    divided = subject / 5
    expect(divided.as_float('USD')).to eq(0.5)
  end

  it "defines #==" do
    usd_10a = described_class.new(10, 'USD')
    usd_10b = described_class.new(10, 'USD')
    usd_1 = described_class.new(1, 'USD')
    gbp_10 = described_class.new(10, 'GBP')
    expect(usd_10a).to eq(usd_10b)
    expect(usd_10b).to eq(usd_10a)
    expect(usd_10a).not_to eq(usd_1)
    expect(usd_10a).not_to eq(gbp_10)
    expect(usd_10a).not_to eq('USD10')
  end

  it "does not allow addition or subtraction to just a number" do
    subject = described_class.new(2500, 'USD')
    expect { subject + 1 }.to raise_error(TypeError)
    expect { subject - 1 }.to raise_error(TypeError)
  end

  it "allows unary negation" do
    subject = described_class.new(2500, 'USD')
    negated = -subject
    expect(negated).to eq(described_class.new(-2500, 'USD'))
  end

  it "is comparable" do
    subjects = (1..5).to_a.map { |amt|
      described_class.new(amt, 'USD')
    }.shuffle
    sorted = subjects.sort
    expect(sorted.map { |ma| ma.as_float('USD') }).to \
      eq([1.0, 2.0, 3.0, 4.0, 5.0])
    subject = subjects.first
    expect(subject <=> described_class.new(12.3, 'GBP')).to be_nil
    expect(subject <=> "Hi there").to be_nil
  end

  it "rounds" do
    money_amount = described_class.new(0.12345, 'USD')
    rounded = money_amount.round(2)
    expect(rounded.as_float('USD')).to eq(0.12)
  end

  describe "when another amount is of the same currency" do
    subject { described_class.new(1000, 'USD') }
    let(:other) { described_class.new(200, 'USD') }

    it "allows division" do
      expect(subject / other).to eq(5.0)
    end

    it "does not allow multiplication" do
      expect { subject * other }.to raise_error(TypeError)
    end

    it "allows addition and subtraction" do
      expect(subject + other).to eq(described_class.new(1200, 'USD'))
      expect(subject - other).to eq(described_class.new(800, 'USD'))
    end
  end

  describe "when another amount is of a different currency" do
    subject { described_class.new(1000, 'USD') }
    let(:other) { described_class.new(200, 'GBP') }

    it "does not allow division" do
      expect { subject / other }.to \
        raise_error(StrictMoney::WrongCurrencyError)
    end

    it "does not allow multiplication" do
      expect { subject * other }.to raise_error(TypeError)
    end

    it "does not allow addition or subtraction" do
      expect { subject + other }.to \
        raise_error(StrictMoney::WrongCurrencyError)
      expect { subject - other }.to \
        raise_error(StrictMoney::WrongCurrencyError)
    end
  end

  describe "when the supported currencies list has been restricted" do
    before do
      StrictMoney.configure do |config|
        config.supported_currencies = %w(USD GBP)
      end
    end

    after do
      StrictMoney.reset_configuration
    end

    it "does not allow instantiation with an unsupported currency" do
      expect { described_class.new(100, 'JPY') }.to \
        raise_error(StrictMoney::UnsupportedCurrencyError)
    end
  end
end
