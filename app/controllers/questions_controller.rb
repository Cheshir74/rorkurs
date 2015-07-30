class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [ :index, :show]
  before_action :load_question, only: [:show, :update, :destroy]
  before_action :build_answer, only: :show
  before_action :author, only: :destroy
  after_action :publish_question, only: :create

  respond_to :html, :js
  authorize_resource

  def index
    respond_with(@questions = Question.all)
  end

  def show
    respond_with @question
  end

  def new
    respond_with(@question = Question.new)
  end

  def edit
  end

  def create
    respond_with(@question = current_user.questions.create(question_params))
  end


  def update
    if current_user.id == @question.user_id
      @question.update(question_params)
      respond_with @question
    end
  end

  def destroy
    respond_with(@question.destroy)
  end

  private

  def load_question
    @question = Question.find(params[:id])
  end

  def build_answer
    @answer = @question.answers.build
  end

  def publish_question
    PrivatePub.publish_to("/questions", question: @question.to_json) if @question.valid?
  end

  def author
    redirect_to root_url, notice: "You are not an author" unless @question.user_id == current_user.id
  end


  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:file])
  end
end
