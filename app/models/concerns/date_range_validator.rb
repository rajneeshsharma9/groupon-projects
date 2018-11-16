class DateRangeValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value.blank?
    if record[options[:greater_than]].present? && value < record[options[:greater_than]]
      record.errors.add(attribute, "cannot be less than the #{options[:greater_than].to_s.humanize}")
    end
    if record[options[:less_than]].present? && value > record[options[:less_than]]
      record.errors.add(attribute, "cannot be greater than the #{options[:less_than].to_s.humanize}")
    end
    if options[:greater_than] == :current_time && value < Time.current
      record.errors.add(attribute, "cannot be less than the current time")
    end
  end
end
