class Question < ActiveRecord::Base
  has_many :answers, -> { order('best DESC') }, dependent: :destroy
  has_many :attachments
  belongs_to :user
  validates :title, :body, :user_id, presence: true
  validates :title, length: { in: 5..140 }
end
