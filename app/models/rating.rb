class Rating < ApplicationRecord
  belongs_to :user
  belongs_to :answer

  validates :user_id, presence: true
  validates :answer_id, presence: true
  validates :value, presence: true, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 0,
    less_than_or_equal_to: 10
  }
end
