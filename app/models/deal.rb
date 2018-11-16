class Deal < ApplicationRecord

  MINIMUM_ALLOWED_PRICE = 0.01
  MAXIMUM_ALLOWED_PRICE = 9999.99
  # Callbacks
  after_create :validate_start_at

  # Associations
  has_many_attached :images

  # Validations
  validates :title, presence: true
  validates :title, uniqueness: { case_sensitive: false }, allow_nil: true
  validates :minimum_purchases_required, numericality: { greater_than_or_equal_to: 0 }
  validates :maximum_purchases_allowed, numericality: { greater_than: :minimum_purchases_required }
  validates :start_at, :expire_at, :price, presence: true
  validates :price, numericality: { greater_than_or_equal_to: MINIMUM_ALLOWED_PRICE }, allow_nil: true
  validates :price, numericality: { less_than_or_equal_to: MAXIMUM_ALLOWED_PRICE }, allow_nil: true
  validates :maximum_purchases_per_customer, numericality: { greater_than_or_equal_to: 0 }
  validates :maximum_purchases_per_customer, numericality: { less_than_or_equal_to: :maximum_purchases_allowed }
  validates :start_at, date_range: { greater_than: :current_time }, on: :create
  validates :start_at, date_range: { greater_than: :created_at }, on: :update
  validates :expire_at, date_range: { greater_than: :start_at }

  private def validate_start_at
    if start_at < created_at
      errors.add(:start_at, 'cannot be less than the current time')
      raise ActiveRecord::Rollback
    end
  end

end
