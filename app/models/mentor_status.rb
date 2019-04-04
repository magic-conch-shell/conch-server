class MentorStatus < ApplicationRecord
  belongs_to :user

  validates :user_id, presence: true
  validates :answering, inclusion: { in: [true, false] }
end
