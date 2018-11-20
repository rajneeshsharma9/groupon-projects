class Deal < ApplicationRecord

  # Assciations
  has_many :deals_locations
  has_many :locations, through: :deals_locations
  belongs_to :category
  MINIMUM_ALLOWED_PRICE = 0.01
  MAXIMUM_ALLOWED_PRICE = 9999.99
  MAXIMUM_ALLOWED_IMAGE_SIZE = 100000

  # Associations
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
  validates :maximum_purchases_per_customer, numericality: { greater_than_or_equal_to: 0 }
  validates :maximum_purchases_per_customer, numericality: { less_than_or_equal_to: :maximum_purchases_allowed }
  validates :start_at, date_range: { greater_than: :current_time }, on: :create
  validates :start_at, date_range: { greater_than: :created_at }, on: :update
  validates :expire_at, date_range: { greater_than: :start_at }
  validate :images_size_constraint

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

end
