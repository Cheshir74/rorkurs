class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [ :index, :show]
  before_action :load_question, only: [:show, :update, :destroy]
 
  def index
    @questions = Question.all
  end

  def show
    @answer = @question.answers.build
    @answer.attachments.build
  end

  def new
    @question = Question.new
    @question.attachments.build
  end

  def edit
  end

  def create
    @question = current_user.questions.new(question_params)
    if @question.save
      PrivatePub.publish_to "/questions", question: @question.to_json
      flash[:notice] = 'Your question successfully created.'
      redirect_to @question
    else
      render :new
    end
  end


  def update
    if current_user.id == @question.user_id
      @question.update(question_params)
    end
  end
  
  def destroy
    if current_user.id == @question.user_id
      @question.destroy
    end
    redirect_to questions_path
  end



  private
  def load_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:file])
  end
end
