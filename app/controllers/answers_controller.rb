class AnswersController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:create]
  before_action :load_answer, only: [:destroy, :update, :set_best]
  def index
    @answer = Answer.all
  end

  def new
    @answer = Answer.new
  end

  def set_best
    if current_user.id == @answer.question.user_id
      @question = @answer.question
      @answer.set_best
    end
  end

  def update
    if current_user.id == @answer.user_id
      @answer.update(answer_params)
      @question = @answer.question
    end
  end

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.create(answer_params)
    @answer.user = current_user
    unless @answer.save
    end
  end

  def destroy
    if current_user.id == @answer.user_id
      @answer.destroy
    end
  end

  private

  def load_answer
    @answer = Answer.find(params[:id])
  end

  def load_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body, :question_id,  attachments_attributes: [:file])
  end

end
