class Deal < ApplicationRecord

  # Validations
  validates :title, presence: true, uniqueness: { case_sensitive: false }
  validates :minimum_purchases_required, numericality: { greater_than_or_equal_to: 0 }
  validates :maximum_purchases_allowed, numericality: { greater_than: :minimum_purchases_required }
  validates :start_time, :expire_time, :price, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0.01 }, allow_nil: true
  validates :maximum_purchases_per_customer, numericality: { greater_than_or_equal_to: 0 }
  validates :maximum_purchases_per_customer, numericality: { less_than_or_equal_to: :maximum_purchases_allowed }
  validate  :expire_time_after_start_time
  validate  :start_time_after_created_at

  private def expire_time_after_start_time
    return if expire_time.blank? || start_time.blank?
    if expire_time < start_time
      errors.add(:expire_time, 'must be after the start time')
    end
  end

  private def start_time_after_created_at
    return if start_time.blank? || created_at.blank?
    if start_time < created_at
      errors.add(:start_time, 'must be after the current time')
    end
  end

end
