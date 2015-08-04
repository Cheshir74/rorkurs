require 'rails_helper'

describe 'Questions API' do

  let!(:user) {create(:user)}
  describe 'GET /index' do
    it_behaves_like "API Authenticable"

    context 'authorized' do
      let(:access_token) {create :access_token}
      let!(:questions) { create_list(:question, 2, user: user)}
      let(:question) { questions.first }
      let!(:answer) {create(:answer, question: question)}

      before { get '/api/v1/questions', format: :json, access_token: access_token.token }

      it 'returns 200 status code' do
        expect(response).to be_success
      end

      it 'returns list of questions' do
        expect(response.body).to have_json_size(2).at_path("questions")
      end

      %w(id title body created_at updated_at).each do |attr|
        it "question object contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("questions/0/#{attr}")
        end
      end

      it 'question object contains short_title' do
        expect(response.body).to be_json_eql(question.title.truncate(10).to_json).at_path("questions/0/short_title")
      end

      context 'answers' do
        it 'included in question object' do
          expect(response.body).to have_json_size(1).at_path("questions/0/answers")
        end

        %w(id body created_at updated_at).each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("questions/0/answers/0/#{attr}")
          end
        end
      end

    end

    def do_request(options = {})
      get '/api/v1/questions', { format: :json }.merge(options)
    end
  end

  describe 'GET /show' do
    let!(:question) { create(:question, user: user) }

    it_behaves_like "API Authenticable"

    context 'authorized' do
      let!(:access_token) { create(:access_token) }
      let!(:comment) { create(:comment, commentable: question) }
      let!(:attachment) { create(:attachment, attachmentable: question) }

      before { get "/api/v1/questions/#{question.id}", format: :json, access_token: access_token.token }

      it 'returns 200 status code' do
        expect(response).to be_success
      end

      %w(id title created_at updated_at body).each do |attr|
        it "question contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("one_question/#{attr}")
        end
      end

      context 'comments' do

        %w(id body created_at updated_at).each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json).at_path("one_question/comments/0/#{attr}")
          end
        end
      end

      context 'attachments' do

        it "contains url" do
          expect(response.body).to be_json_eql(question.attachments[0].file.url.to_json).at_path("one_question/attachments/0/url")
        end
      end
    end

    def do_request(options = {})
      get "/api/v1/questions/#{question.id}", { format: :json }.merge(options)
    end

  end
  describe 'POST /create' do
    it_behaves_like "API Authenticable"

    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }
      let(:request) { post "/api/v1/questions", format: :json, question: attributes_for(:question), access_token: access_token.token}

      context 'with valid attributes' do
        it 'returns 201 status code' do
          request
          expect(response).to have_http_status :created
        end

        it 'saves the new question in the database' do
          expect {request }.to change(Question, :count).by(1)
        end

        it 'assigns created question to the user' do
          expect {request}.to change(me.questions, :count).by(1)
        end
      end

      context 'with invalid attributes' do
        let(:request) {post "/api/v1/questions", format: :json, question: attributes_for(:invalid_question), access_token: access_token.token}
        it 'returns 401 status code' do
          request
          expect(response).to have_http_status :unprocessable_entity
        end

        it 'do not save the new question in the database' do
          expect { request }.to_not change(Question, :count)
        end

        it 'do not assign created question to the user' do
          expect { request }.to_not change(me.questions, :count)
        end
      end
    end

    def do_request(options = {})
      post "/api/v1/questions", { format: :json }.merge(options)
    end
  end
end