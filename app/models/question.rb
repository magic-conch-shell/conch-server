class Question < ApplicationRecord
  belongs_to :user

  has_many :question_tags
  has_many :answers
  has_one :question_status

  validates :user_id, presence: true
  validates :content, presence: true
  validates :solved, inclusion: { in: [true, false] }

  def tags
    question_tags.map { |tag| tag[:tag_id] }
  end
end
