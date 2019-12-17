class MongoidProduct
  include Mongoid::Document

  field :price, type: StrictMoney::Amount
  field :discount, type: StrictMoney::Amount

  validates :price, financiality: { positive: true }
  validates :discount, financiality: { allow_nil: true, not_negative: true }
end

Mongoid.load!("./spec/mongoid.yml", :test)
