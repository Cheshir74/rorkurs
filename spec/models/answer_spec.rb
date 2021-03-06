require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should validate_presence_of :body }
  it { should belong_to(:question) }
  it { should validate_presence_of :question_id }
  it { should belong_to(:user)}
  it { should validate_presence_of :user_id}

  it { should have_many :attachments }
  it { should accept_nested_attributes_for :attachments }
  it { should have_many :votes}
  it { should have_many :comments}

  describe 'best answer' do

    let(:user) { create(:user)}
    let!(:question) { create(:question, user: user)}
    let(:answer1) { create(:answer, question: question, best: false)}
    let(:answer2) { create(:answer, question: question, best: false)}
    let!(:answer) { create(:answer, question: question, best: true)}


    it 'set best answer' do
      answer1.set_best
      expect(answer1.best).to eq true
    end

    it 'other answer set best' do
      answer2.set_best
      answer.reload

      expect(answer.best).to eq false
      expect(answer2.best).to eq true
    end
  end

  describe '.send_notification_answer_new' do
    let(:owner_question) { create(:user) }
    let(:user) { create(:user) }
    let!(:question) {create(:question, user: owner_question) }
    let(:answer) { create(:answer, question: question, user: user)}

    subject { build(:answer, question: question) }

    it 'should not call notification job after update' do
      subject.save!
      expect(AnswerNew).to_not receive(:notification)
      subject.touch
    end

    it 'should send notification new answer for owner question' do
      expect(NotificationJob).to receive(:perform_later).with(question).and_call_original
      #Answer.send_notification(question.user)

      answer
    end

  end

end
