require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create :question, user: user }
  describe 'GET #new' do
    sign_in_user
    before do
      question
      get :new, question_id: question.id
    end
    it 'assign new answer for @answers' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end
    
    it 'render a new view' do
      expect(response).to render_template :new
    end
  end    

  describe 'POST #create' do
    sign_in_user
    let(:question) { create :question, user: user }
    let(:answer) { create(:answer, question: question, user: user) }
    context 'valid attributes' do
      it 'saved answer in db' do
        expect { post :create, question_id: question, user: user, answer: attributes_for(:answer)}.to change(question.answers, :count).by(1)
      end
      
      it 'redirect to question' do
        post :create, question_id: question, answer: attributes_for(:answer)
        expect(response).to redirect_to question_path(question)
      end
    end
    context 'invalid attibutes' do
      it 'not create answer' do
        expect { post :create, question_id: question, answer: attributes_for(:invalid_answer)}.to_not change(Answer, :count)
      end
      it 're-render question with answers' do
        post :create, answer: attributes_for(:invalid_answer), question_id: question
        expect(response).to render_template 'questions/show'
      end
    end  
  end

  describe 'DELETE #destroy' do    
    sign_in_user
    let(:question) { create :question, user: user }
    let(:answer) { create(:answer, question: question, user: subject.current_user) }
        
    it 'delete answer' do
      @answer =  create(:answer, question: question, user: subject.current_user)
      expect {delete :destroy, question_id: question, id: @answer}.to change(subject.current_user.answers, :count).by(-1)
    end
    
    it 'delete other answer' do
      @answer = create(:answer, question: question, user: user)
      expect {delete :destroy, question_id: question, id: @answer}.to_not change(Answer, :count)
    end
    
    it 'redirect to question show' do
      delete :destroy, question_id: question, id: answer
      expect(response).to redirect_to question_path(question)
    end
    
  end
end
