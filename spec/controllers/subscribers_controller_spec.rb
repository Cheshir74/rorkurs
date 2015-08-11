require 'rails_helper'

RSpec.describe SubscribersController, type: :controller do
  let(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }

  describe 'POST #create' do
    sign_in_user
    let!(:user) { create(:user) }

    it 'save new subscriber' do
      expect{ post :create, question_id: question, user_id: user, format: :js }.to change(Subscriber, :count).by(1)
    end

    it 'render create template' do
      post :create, question_id: question, user_id: user, format: :js
      expect(response).to render_template :create
    end

    it 'Subscriber associated with question' do
      post :create, question_id: question, user_id: user, format: :js
      expect(assigns(:subscriber)[:question_id]).to eq question.id
    end
  end
end