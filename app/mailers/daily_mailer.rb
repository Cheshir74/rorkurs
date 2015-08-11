class DailyMailer < ApplicationMailer

  def digest(user)
    @questions = Question.where("created_at >= ?", Time.zone.now.beginning_of_day)

    mail to: user.email
  end
end
