class DailyMailer < ApplicationMailer

  def digest(user)
    @question = Question.new_questions
    mail to: user.email
  end
end
