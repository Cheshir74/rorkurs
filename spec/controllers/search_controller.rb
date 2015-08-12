require 'rails_helper'

RSpec.describe SearchController, type: :controller do

  describe 'GET #index' do

    it 'find Answer' do
      expect(Answer).to receive(:search).with("TestAnswer")
      get :index, type: "Answers", query: "TestAnswer"
    end

    it 'find Question' do
      expect(Question).to receive(:search).with("TestQuestion")
      get :index, type: "Questions", query: "TestQuestion"
    end

    it 'find User' do
      expect(User).to receive(:search).with("TestUser")
      get :index, type: "Users", query: "TestUser"
    end

    it 'find Comment' do
      expect(Comment).to receive(:search).with("TestComment")
      get :index, type: "Comments", query: "TestComment"
    end

    it 'find All' do
      expect(ThinkingSphinx).to receive(:search).with("All Test")
      get :index, type: "All", query: "All Test"
    end
  end

end