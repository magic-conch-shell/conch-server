class Tag < ApplicationRecord
  has_many :user_tags
  has_many :question_tags

  validates :name, presence: true
end
