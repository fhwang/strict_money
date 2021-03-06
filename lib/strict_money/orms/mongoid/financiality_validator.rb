# Supply validation macros for Mongoid classes that embed StrictMoney::Amount.
class FinancialityValidator < ActiveModel::EachValidator
  def check_validity!
    invalid_keys = options.keys - [:allow_nil, :positive, :not_negative]
    raise "Invalid keys #{invalid_keys.inspect} for financiality validator" if invalid_keys.present?
  end

  def validate_each(*args)
    validate_positive(*args) if options[:positive]
    validate_not_negative(*args) if options[:not_negative]
  end

  private

  def validate_not_negative(record, attribute, value)
    if value.present? && value.negative?
      record.errors.add(attribute, "can't be negative")
    end
  end

  def validate_positive(record, attribute, value)
    if value.present? && !value.positive?
      record.errors.add(attribute, "must be greater than 0")
    end
  end
end
