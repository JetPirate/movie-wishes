class User < ApplicationRecord
  has_secure_password

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze

  before_save :downcase_email

  validates :login, presence: true, length: { maximum: 50 }

  validates :email, confirmation: true
  validates_presence_of :email_confirmation, if: :email_changed?
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: 8 },
                       confirmation: true, on: :create
  validates_presence_of :password_confirmation, if: :password_digest_changed?

  private

  def downcase_email
    self.email = email.downcase
  end
end
