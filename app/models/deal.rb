class Deal < ApplicationRecord

  MINIMUM_ALLOWED_PRICE = 0.01
  MAXIMUM_ALLOWED_PRICE = 9999.99
  MAXIMUM_ALLOWED_IMAGE_SIZE = 100000
  # Assciations
  has_many :deals_locations, dependent: :destroy
  has_many :locations, through: :deals_locations
  belongs_to :category
  has_many_attached :images
  accepts_nested_attributes_for :images_attachments, allow_destroy: true
  # Callbacks
  after_create :validate_start_at
  before_update :purge_images
  # Validations
  validates :title, presence: true
  validates :title, uniqueness: { case_sensitive: false }, allow_nil: true
  validates :minimum_purchases_required, numericality: { greater_than_or_equal_to: 0 }
  validates :maximum_purchases_allowed, numericality: { greater_than: :minimum_purchases_required }
  validates :start_at, :expire_at, :price, presence: true
  validates :price, numericality: { greater_than_or_equal_to: MINIMUM_ALLOWED_PRICE }, allow_nil: true
  validates :price, numericality: { less_than_or_equal_to: MAXIMUM_ALLOWED_PRICE }, allow_nil: true
  validates :maximum_purchases_per_customer, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :maximum_purchases_per_customer, numericality: { less_than_or_equal_to: :maximum_purchases_allowed }, allow_nil: true
  validates :start_at, date_range: { greater_than: :current_time }, on: :create
  validates :start_at, date_range: { greater_than: :created_at }, on: :update
  validates :expire_at, date_range: { greater_than: :start_at }
  validate :images_size_constraint
  validate :check_publishability, on: :update, if: :published_at_changed?
  validate :check_if_live_or_expired, on: :update, unless: :published_at_changed?

  private def validate_start_at
    if start_at < created_at
      errors.add(:start_at, 'cannot be less than the current time')
      raise ActiveRecord::Rollback
    end
  end

  private def purge_images
    images_attachments.each do |image_attachment|
      if image_attachment.marked_for_destruction?
        image_attachment.blob.purge_later
      end
    end
  end

  private def images_size_constraint
    images.each do |image|
      if image.blob && image.blob.byte_size > MAXIMUM_ALLOWED_IMAGE_SIZE
        image.purge
        image.blob.purge
        errors.add(:images, 'only 100 kb image allowed')
      end
    end
  end

  private def check_publishability
    if locations.count < 1
      errors.add(:base, 'cannot be published as no locations present')
    end
    if images.count < 1
      errors.add(:base, 'cannot be published as no images present')
    end
  end

  private def check_if_live_or_expired
    if published_at.present? || expire_at < Time.current
      errors.add(:base, 'Live or expired deals cannot be updated')
    end
  end

end
