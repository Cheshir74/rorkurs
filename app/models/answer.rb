class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :user
  
  validates :question_id, :user_id, presence: true
  validates :body, length: { in: 5..140 }, presence: true

  def set_best
    transaction do
      question.answers.update_all(best: false)
      update!(best: true)
    end
  end
end
