class Collection < ApplicationRecord

  define_model_callbacks :publish, only: [:before]
  define_model_callbacks :unpublish, only: [:before]

  # Associations
  has_many :deals
  # Callbacks
  before_publish :publish_associated_deals
  before_unpublish :unpublish_associated_deals

  # Validations
  validates :name, presence: true
  validates :name, uniqueness: { case_sensitive: false }, allow_blank: true

  def publish
    Collection.transaction do
      run_callbacks :publish do
        update(published_at: Time.current)
      end
    end
  end

  def unpublish
    Collection.transaction do
      run_callbacks :unpublish do
        update(published_at: nil)
      end
    end
  end

  private def publish_associated_deals
    deals.each do |deal|
      unless deal.publish
        errors.add(:base, "#{deal.title}: #{deal.errors.full_messages.join(', ')}")
      end
    end
    if errors.present?
      throw :abort
    end
  end

  private def unpublish_associated_deals
    deals.each do |deal|
      unless deal.unpublish
        errors.add(:base, "#{deal.title}: #{deal.errors.full_messages.join(', ')}")
      end
    end
    if errors.present?
      throw :abort
    end
  end

end
