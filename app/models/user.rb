class User < ApplicationRecord
  has_secure_password
  attr_accessor :reset_token

  has_one_attached :profile_picture

  has_many :questions
  has_many :ratings
  has_many :user_tags
  has_many :answers
  has_many :comments
  has_one :mentor_status

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

  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def self.new_token
    SecureRandom.urlsafe_base64
  end

  def create_reset_digest
    self.reset_token = User.new_token
    update_attribute(:reset_digest,  User.digest(reset_token))
    update_attribute(:reset_sent_at, Time.zone.now)
  end

  # Sends password reset email.
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  def authenticated?(remember_token)
    BCrypt::Password.new(reset_digest).is_password?(remember_token)
  end

  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  private

  def email_must_contain_alpha
    errors.add(:email, 'Not a valid email') unless email.include?('@')
  end
end
