class Answer < ApplicationRecord
  belongs_to :user
  belongs_to :question

  has_many :ratings
  has_many :comments

  validates :user_id, presence: true
  validates :question_id, presence: true
  validates :content, presence: true
  validates :selected, inclusion: { in: [true, false] }
end
