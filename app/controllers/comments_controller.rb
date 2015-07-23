class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_commentable

  def create
    @comment = Comment.new(commentable: @commentable, user_id: current_user.id, body: comment_params[:body])
    @question = @comment.commentable_type == 'Question' ? @comment.commentable : @comment.commentable.question
    @comment.save
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end

  def load_commentable
    @commentable =  params[:question_id] ? Question.find(params[:question_id]) : Answer.find(params[:answer_id])
  end
end
