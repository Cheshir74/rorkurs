class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_commentable

  respond_to :js
  authorize_resource

  def create
    respond_with(@comment = current_user.comments.create(commentable: @commentable,  body: comment_params[:body]))
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end

  def load_commentable
    @commentable =  params[:question_id] ? Question.find(params[:question_id]) : Answer.find(params[:answer_id])
  end
end
