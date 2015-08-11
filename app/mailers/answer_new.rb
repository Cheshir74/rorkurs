class AnswerNew < ApplicationMailer

  def notification(user)
    mail to: user.email
  end
end
