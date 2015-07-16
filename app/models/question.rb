class Question < ActiveRecord::Base
  has_many :answers, -> { order('best DESC') }, dependent: :destroy
  has_many :attachments, as: :attachmentable, dependent: :destroy
  belongs_to :user
  validates :title, :body, :user_id, presence: true
  validates :title, length: { in: 5..140 }

  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true
end
