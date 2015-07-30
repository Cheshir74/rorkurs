class VotesController < ApplicationController
  before_action :authenticate_user!
  before_action :load_votable
  before_action :author_votable

  respond_to :json

  def vote_up
    authorize! :vote_up, @votable
    vote 1

  end

  def vote_down
    authorize! :vote_down, @votable
    vote -1
  end

  def vote_destroy
    authorize! :vote_destroy, @votable
    @vote = Vote.find_by(user_id: current_user.id, votable: @votable)
    if @vote.user_id == current_user.id
      @vote.destroy
      render json: { count_votes: @vote.votable.count_votes, votable_type: @vote.votable_type, votable_id: @vote.votable_id }
    else
      render json: ["Your not vote."], status: :forbidden
    end
  end

  private

  def vote(value)
    @vote = Vote.new(value: value, user_id: current_user.id, votable: @votable)
    if @vote.save
      render json: { count_votes: @vote.votable.count_votes, votable_type: @vote.votable_type, votable_id: @vote.votable_id }
    end
  end


  def load_votable
    @votable =  params[:question_id] ? Question.find(params[:question_id]) : Answer.find(params[:answer_id])
  end


  def author_votable
    render nothing: true, status: :forbidden unless @votable.user_id != current_user.id
  end

end
