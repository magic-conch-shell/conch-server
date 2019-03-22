class User < ApplicationRecord
  has_secure_password

  has_many :questions
  has_many :ratings
  has_many :user_tags
  has_many :answers
  has_many :comments

  validates :nickname, presence: true
  validates :email, presence: true, uniqueness: true
  validates :phone, presence: true, uniqueness: true
  validates :password_digest, presence: true
  validates :points, presence: true, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 0
  }
  validates :is_mentor, inclusion: { in: [true, false] }

  validate :email_must_contain_alpha

  private

  def email_must_contain_alpha
    errors.add(:email, 'Not a valid email') unless email.include?('@')
  end
end
