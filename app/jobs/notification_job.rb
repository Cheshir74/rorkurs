class NotificationJob < ActiveJob::Base
  queue_as :default

  def perform(question)
    AnswerNew.notification(question.user).deliver_later
    question.subscribers.find_each.each do |subscriber|
      AnswerNew.notification(subscriber).deliver_later
    end
  end
end
