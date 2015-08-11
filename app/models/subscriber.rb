class Subscriber < ActiveRecord::Base
  belongs_to :user
  belongs_to :question

  validates :question_id, presence: true
  validates :user_id, presence: true, uniqueness: { scope: :question_id }
end