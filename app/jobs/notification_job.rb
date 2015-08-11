class NotificationJob < ActiveJob::Base
  queue_as :default

  def perform(question)
    Answer.send_notification(question)
  end
end
