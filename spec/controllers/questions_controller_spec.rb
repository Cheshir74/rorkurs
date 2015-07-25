require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do

  let(:user) { create(:user) }
  let(:question) { create :question, user: user }
  
  describe 'GET #index' do
    let(:questions) {create_list(:question, 2, user: user) }

    before { get :index }

    it 'populates an array af all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before do
      get :show, id: question
    end

    it 'assings the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    sign_in_user
    before { get :new }

    it 'assigns a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end   
  end

  describe 'GET #update' do

    let(:otheruser){create(:user)}

    it 'Question owner edit question' do
      sign_in(user)
      patch :update, id: question, question: {title:'New title question', body:'New body question'}, format: :js
      question.reload
      expect(question.title).to eq 'New title question'
      expect(question.body).to eq 'New body question'
    end

    it 'Other user edit question' do
      sign_in(otheruser)
      patch :update, id: question, question: {title:'New title question', body:'New body question'}, format: :js
      question.reload
      expect(question.title).to_not eq 'New title question'
      expect(question.body).to_not eq 'New body question'
    end

    it 'Guest edit question' do
      patch :update, id: question, question: {title:'New title question', body:'New body question'}, format: :js
      question.reload
      expect(question.title).to_not eq 'New title question'
      expect(question.body).to_not eq 'New body question'
    end

  end

  describe 'POST #create' do
    sign_in_user
    context 'with valid attributes' do
      it 'saves the new question in the database' do
        expect { post :create, question: attributes_for(:question) }.to change(Question, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, question: attributes_for(:question)
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end
    context 'with invalid attributes' do
      it 'does not save the question' do
       expect { post :create, question: attributes_for(:invalid_question) }.to_not change(Question, :count)

      end
      it 're-renders new view' do
        post :create, question: attributes_for(:invalid_question)
        expect(response).to render_template :new

      end
    end 
  end

  describe 'DELETE #destroy' do
    sign_in_user

    it 'delete question' do
      @question = create(:question, user: subject.current_user)
      expect {delete :destroy, id: @question}.to change(subject.current_user.questions, :count).by(-1)
    end
    
    it 'delete other question' do
      question.user = create(:user)
      expect {delete :destroy, id: question}.to_not change(Question, :count)
    end
    
    it 'redirect to index view' do
      @question = create(:question, user: subject.current_user)
      delete :destroy, id: @question
      expect(response).to redirect_to questions_path
    end
  end  
end
