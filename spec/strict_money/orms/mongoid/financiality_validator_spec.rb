RSpec.describe FinancialityValidator do
  it "validates for positive" do
    product = MongoidProduct.new(
      price: StrictMoney::Amount.new(-100, 'USD'),
      discount: StrictMoney::Amount.new(1, 'USD')
    )
    expect(product).not_to be_valid
    expect(product.errors[:price]).to include("must be greater than 0")
  end

  it "validates for not negative" do
    product = MongoidProduct.new(
      price: StrictMoney::Amount.new(100, 'USD'),
      discount: StrictMoney::Amount.new(-1, 'USD')
    )
    expect(product).not_to be_valid
    expect(product.errors[:discount]).to include("can't be negative")
  end
end
