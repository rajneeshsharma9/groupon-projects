class DateValidator < ActiveModel::Validator
  def validate(record)
    return if record.start_at.blank? || record.expire_at.blank?
    if record.created_at.present? && record.start_at < record.created_at
      record.errors.add(:start_at, 'should be greater than created at of deal')
    end
    if record.expire_at <= record.start_at
      record.errors.add(:expire_at, 'should be greater than start datetime of deal')
    end
  end
end
