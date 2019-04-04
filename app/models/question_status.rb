class QuestionStatus < ApplicationRecord
  belongs_to :question

  validates :question_id, presence: true
  validates :status, presence: true
end
