require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:user) { create(:user)}
  let!(:question)  { create(:question, user: user) }
  let!(:answer)    { create(:answer, question: question, user: user) }
  let!(:comment)   { create(:comment, user: user) }

  describe "POST #create" do

    context "User create comment" do
      sign_in_user

      it "for question" do
        expect { post :create, question_id: question, comment: attributes_for(:comment), format: :js }.to change(question.comments, :count).by(1)
      end

      it "for answer" do
        expect { post :create, answer_id: answer, comment: attributes_for(:comment), format: :js }.to change(answer.comments, :count).by(1)
      end

      it "send OK" do
        post :create, question_id: question, comment: attributes_for(:comment), format: :js
        expect(response).to have_http_status(200)
      end
    end

    context "Guest can not create comment" do

      it "try to save comment" do
        expect { post :create, question_id: question, comment: attributes_for(:comment), format: :js }.to_not change(Comment, :count)
      end

      it "send ERROR" do
        post :create, question_id: question, comment: attributes_for(:comment), format: :js
        expect(response).to have_http_status(401)
      end
    end
  end
end