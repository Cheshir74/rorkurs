class Answer < ActiveRecord::Base
  belongs_to :question
  validates :body, :question_id, presence: true
  validates :body, length: { in: 5..140 }
end
