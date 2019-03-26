class User < ApplicationRecord
  has_secure_password

  has_many :questions
  has_many :ratings
  has_many :user_tags
  has_many :answers
  has_many :comments

  validates :nickname, presence: true
  validates :email, presence: true, uniqueness: true
  #validates :phone, presence: true, uniqueness: true
  validates :password_digest, presence: true
  validates :points, presence: true, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 0
  }
  validates :is_mentor, inclusion: { in: [true, false] }

  validate :email_must_contain_alpha

  def self.authenticate_with_credentials(log_email, log_password)
    @newUser = nil
    # user = User.find_by_email(log_email.strip)
    user = User.where('lower(email) = ?', log_email.strip.downcase).first
    @newUser = user if user && user.authenticate(log_password)
  end

  private

  def email_must_contain_alpha
    errors.add(:email, 'Not a valid email') unless email.include?('@')
  end
end
