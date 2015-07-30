class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_question, only: [:create]
  before_action :load_answer, only: [:destroy, :update, :set_best]
  before_action :load_question_answer, only: [:update, :set_best]

  authorize_resource

  respond_to :js
  def set_best
    respond_with(@answer.set_best)
  end

  def update
    @answer.update(answer_params)
    respond_with @answer
  end

  def create
    respond_with(@answer = @question.answers.create(answer_params.merge(user: current_user)))
  end

  def destroy
    respond_with(@answer.destroy)
  end

  private

  def load_answer
    @answer = Answer.find(params[:id])
  end

  def load_question
    @question = Question.find(params[:question_id])
  end

  def load_question_answer
    @question = @answer.question
  end

  def answer_params
    params.require(:answer).permit(:body, :question_id,  attachments_attributes: [:file])
  end

end
