class Answer < ActiveRecord::Base
  include Votable
  include Commentable

  belongs_to :question
  belongs_to :user
  has_many :attachments, as: :attachmentable, dependent: :destroy
  validates :question_id, :user_id, presence: true
  validates :body, length: { in: 5..140 }, presence: true

  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true

  after_create :jobs_notif
  def set_best
    transaction do
      question.answers.update_all(best: false)
      update!(best: true)
    end
  end

  def jobs_notif
    NotificationJob.perform_now(question)
  end

  def self.send_notification(question)
    AnswerNew.notification(question.user).deliver_later
    question.subscribers.find_each.each do |subscriber|
      AnswerNew.notification(subscriber).deliver_later
    end
  end

end
