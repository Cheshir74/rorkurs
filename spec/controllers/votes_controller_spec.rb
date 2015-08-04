require 'rails_helper'

RSpec.describe VotesController, type: :controller do

  let(:user)  { create(:user) }
  let!(:question) { create(:question, user: user) }
  let!(:answer)   { create(:answer, question: question, user: user)}

  describe "POST #vote-up" do

    context "user can vote up" do

      before do
        sign_in(create(:user))
      end

      it "for the question" do
        expect {post :vote_up, question_id: question.id, id: question, votable: question, format: :json}.to change{question.votes.sum(:value)}.by(1)
      end

      it "for the answer" do
        expect {post :vote_up, answer_id: answer.id, id: answer, votable: answer, format: :json}.to change{answer.votes.sum(:value)}.by(1)
      end

      it "send OK to client from server" do
        post :vote_up, question_id: question.id, id: question, votable: question, format: :json
        expect(response).to have_http_status(200)
      end
    end

    context "Guest user" do

      it "try to vote up" do
        expect {post :vote_up, question_id: question.id, id: question, votable: question, format: :json}.to_not change(Vote, :count)
      end

      it "send to client from server" do
        post :vote_up, question_id: question.id, id: question, votable: question, format: :json
        expect(response).to have_http_status(401)
      end
    end

    context "author can not vote up for your questions or answers" do

      before do
        sign_in(user)
      end

      it "author can not do it" do
        expect {post :vote_up, question_id: question.id, id: question,
                     votable: question, format: :json}.to_not change(Vote, :count)
      end

      it "send to client from server" do
        post :vote_up, question_id: question.id, id: question, votable: question, format: :json
        expect(response).to have_http_status(403)
      end
    end
  end



  describe "POST #vote-down" do

    context "user can vote down " do

      before do
        sign_in(create(:user))
      end

      it "for the question" do
        expect {post :vote_down, question_id: question.id, id: question,
                     votable: question, format: :json}.to change {question.votes.sum(:value)}.by(-1)
      end

      it "for the answer" do
        expect {post :vote_down, answer_id: answer.id, id: answer,
                     votable: answer, format: :json}.to change {answer.votes.sum(:value)}.by(-1)
      end

      it "send OK to client from server" do
        post :vote_down, question_id: question.id, id: question, votable: question, format: :json
        expect(response).to have_http_status(200)
      end
    end

    context "Guest user" do

      it "try to vote down" do
        expect {post :vote_down, question_id: question.id, id: question,
                     votable: question, format: :json}.to_not change(Vote, :count)
      end

      it "send to client from server" do
        post :vote_down, question_id: question.id, id: question, votable: question, format: :json
        expect(response).to have_http_status(401)
      end
    end

    context "author can not vote down for your questions or answers" do

      before do
        sign_in(user)
      end

      it "author can not do it" do
        expect {post :vote_down, question_id: question.id, id: question,
                     votable: question, format: :json}.to_not change(Vote, :count)
      end

      it "send to client from server" do
        post :vote_up, question_id: question.id, id: question, votable: question, format: :json
        expect(response).to have_http_status(403)
      end
    end
  end




  describe "POST #vote-destroy" do
    let(:request_destroy) { post :vote_destroy, question_id: question.id, id: question, votable: question, format: :json }

    context "user cancel vote " do

      before do
        sign_in(create(:user))
      end
      let(:request) { post :vote_down, question_id: question.id, id: question, votable: question, format: :json }

      it "for the question" do
        request
        expect {request_destroy}.to change {question.votes.count}.by(-1)
      end

      it "for the answer" do
        post :vote_up, answer_id: answer.id, id: answer, votable: answer, format: :json
        expect {post :vote_destroy, answer_id: answer.id, id: answer,
                     votable: answer, format: :json}.to change {answer.votes.count}.by(-1)
      end

      it "send OK to client from server" do
        request
        expect(response).to have_http_status(200)
      end
    end

    context "Guest user" do

      it "try to vote cancel" do
        post :vote_up, answer_id: answer.id, id: answer, votable: answer, format: :json
        expect {request_destroy}.to_not change(Vote, :count)
      end

      it "send to client from server" do
        post :vote_up, question_id: question.id, id: question, votable: question, format: :json
        expect(response).to have_http_status(401)
      end
    end

    context "author can not vote cancel for your questions or answers" do

      before do
        sign_in(user)
        post :vote_up, answer_id: answer.id, id: answer, votable: answer, format: :json
      end



      it "author can not do it" do
        expect {request_destroy}.to_not change(Vote, :count)
      end

      it "send to client from server" do
        request_destroy
        expect(response).to have_http_status(403)
      end
    end
  end

end