class User < ApplicationRecord

  include Authenticator
  attr_accessor :reset_token

  ROLES = ({ customer: 0, admin: 1 }).freeze
  PASSWORD_VALIDATION_RANGE = (6..20).freeze

  has_secure_password

  enum role: ROLES
  # Associations
  has_many :orders, dependent: :restrict_with_error
  has_one :current_order, -> { where.not(workflow_state: %w[completed cancelled]).last }, class_name: 'Order'
  # Callbacks
  before_create :set_verification_token
  after_create_commit :send_verification_email
  before_update :send_password_reset_email, if: :reset_digest_changed?
  # Validations
  validates :name, presence: true
  validates :email, presence: true
  validates :email, uniqueness: { case_sensitive: false }, format: {
    with:    EMAIL_REGEXP,
    message: :invalid_email
  }, allow_blank: true
  validates :verification_token, uniqueness: { case_sensitive: false }, allow_nil: true
  validates :password, length: { in: PASSWORD_VALIDATION_RANGE }, allow_blank: true
end
