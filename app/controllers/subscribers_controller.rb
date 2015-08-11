class SubscribersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_question, only: :create

  respond_to :js
  authorize_resource

  def create
    respond_with(@subscriber = @question.subscribers.create(user: current_user))
  end

  private

  def load_question
    @question = Question.find(params[:question_id])
  end
end