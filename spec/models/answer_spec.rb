require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should validate_presence_of :body }
  it { should belong_to(:question) }
  it { should validate_presence_of :question_id }
  it { should belong_to(:user)}
  it { should validate_presence_of :user_id}

  describe 'best answer' do

    let(:user) { create(:user)}
    let!(:question) { create(:question, user: user)}
    let(:answer1) { create(:answer, question: question, best: false)}
    let(:answer2) { create(:answer, question: question, best: false)}


    it 'set best answer' do
      answer1.set_best
      expect(answer1.best).to eq true
    end

    it 'other answer set best' do
      answer1.set_best
      answer2.set_best
      answer1.reload

      expect(answer1.best).to eq false
      expect(answer2.best).to eq true
    end
  end

end
