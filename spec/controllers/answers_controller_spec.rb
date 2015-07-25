require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let!(:question) { create :question, user: user }

  describe 'POST #create' do
    sign_in_user

    let(:answer) { create(:answer, question: question, user: user) }
    context 'valid attributes' do
      it 'saved answer in db' do
        expect { post :create, question_id: question, user: user, answer: attributes_for(:answer), format: :js }.to change(question.answers, :count).by(1)
      end
      
      it 'render create template' do
        post :create, question_id: question, answer: attributes_for(:answer), format: :js
        expect(response).to render_template :create
      end
    end
    context 'invalid attibutes' do
      it 'not create answer' do
        expect { post :create, question_id: question, answer: attributes_for(:invalid_answer), format: :js }.to_not change(Answer, :count)
      end
      it 're-render question with answers' do
        post :create, answer: attributes_for(:invalid_answer), question_id: question, format: :js
        expect(response).to render_template :create
      end
    end  
  end

  describe 'DELETE #destroy' do    
    sign_in_user

    let(:answer) { create(:answer, question: question, user: subject.current_user) }
        
    it 'delete answer' do
      @answer =  create(:answer, question: question, user: subject.current_user)
      expect {delete :destroy, question_id: question, id: @answer}.to change(subject.current_user.answers, :count).by(-1)
    end
    
    it 'delete other answer' do
      @answer = create(:answer, question: question, user: user)
      expect {delete :destroy, question_id: question, id: @answer}.to_not change(Answer, :count)
    end


  end

  describe 'PATCH #update' do
    sign_in_user

    let!(:answer) { create(:answer, question: question, user: subject.current_user) }
    context 'valid attributes' do
      it 'assings the requested answer to @answer' do
        patch :update, id: answer, question_id: question, user: subject.current_user, answer: attributes_for(:answer), format: :js
        expect(assigns(:answer)).to eq answer
      end

      it 'changes answer attributes' do
        patch :update, id: answer, question_id: question, user: subject.current_user, answer: { body: 'new body'}
        answer.reload
        expect(answer.body).to eq 'new body'
      end

      it 'assigns th question' do
        patch :update, id: answer, question_id: question, answer: attributes_for(:answer), format: :js
        expect(assigns(:question)).to eq question
      end

      it 'render update template to the updated question' do
        patch :update, id: answer, question_id: question, answer: attributes_for(:answer), format: :js
        expect(response).to render_template :update
      end
    end
    context 'with invalid attributes' do

      before { patch :update, id: answer, question_id: question, answer: attributes_for(:answer), format: :js }

      it 'does not saves specified answer with received attributes' do

        answer.reload
        expect(answer.body).to_not eq attributes_for(:invalid_question)[:body]

        expect(answer.body).to eq answer.body

      end

      it 'rerenders edit page' do
        expect(response).to render_template :update
      end

    end
  end

  describe 'PATCH #set_best' do
    let(:otheruser){(create(:user))}
    let!(:answer) { create(:answer, question: question, user: otheruser) }
    let!(:answer2) { create(:answer, question: question, user: otheruser) }

    it 'Question owner set best answer' do
      sign_in user

      patch :set_best, id: answer.id, format: :js
      patch :set_best, id: answer2.id, format: :js
      answer.reload
      answer2.reload

      expect(answer.best).to eq false
      expect(answer2.best).to eq true
    end

    it 'Render set_best view' do
      sign_in user
      patch :set_best, id: answer.id, format: :js
      expect(response).to render_template ('set_best')
    end

    it 'Not owner question no select bese answer' do
      sign_in otheruser

      patch :set_best, id: answer.id, format: :js
      answer.reload
      expect(answer.best).to eq false
    end

    it 'Guest try select best answer' do
      patch :set_best, id: answer.id, format: :js
      answer.reload
      expect(answer.best).to eq false
    end

  end
end
