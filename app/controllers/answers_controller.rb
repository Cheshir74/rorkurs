class AnswersController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]

  def index
    @answer = Answer.all
  end

  def new
    @answer = Answer.new
  end

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    unless @answer.save
       render 'questions/show'
    end
  end

  def destroy
    @answer = Answer.find(params[:id])
    if current_user.id == @answer.user_id
      @answer.destroy
    end
    redirect_to question_path(@answer.question)
  end

  private
  def answer_params
    params.require(:answer).permit(:body, :question_id)
  end

end
