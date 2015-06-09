require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  describe 'GET #create' do
    let(:question) { create(:question) }
    let(:answer) { create(:answer, question: question) }
    describe 'POST #create' do
      context 'valid attributes' do
        it 'saved answer in db' do
          expect { post :create, question_id: question, answer: attributes_for(:answer)}.to change(question.answers, :count).by(1)
        end
      
        it 'redirect to question' do
          post :create, question_id: question, answer: attributes_for(:answer)
          expect(response).to redirect_to question_path(question)
        end
     end
    context 'invalid attibutes' do
      it 'not change' do
        expect { post :create, question_id: question, answer: attributes_for(:invalid_answer)}.to_not change(question.answers, :count)
      end
      it 'not create answer' do
        expect { post :create, question_id: question, answer: attributes_for(:invalid_answer)}.to_not change(Answer, :count)
      end
      it 're-render question with answers' do
        post :create, answer: attributes_for(:invalid_answer), question_id: question
        expect(response).to render_template 'questions/show'
      end
    end

    end  
  end
end
