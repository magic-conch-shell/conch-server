class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :answer

  validates :user_id, presence: true
  validates :answer_id, presence: true
  validates :content, presence: true
end
