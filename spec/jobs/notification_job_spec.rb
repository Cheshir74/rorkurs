require 'rails_helper'

RSpec.describe NotificationJob, type: :job do
  let(:user) { create :user}
  let(:question) {create(:question, user: user)}

  it 'sends notification new answers' do
    expect(AnswerNew).to receive(:notification).and_call_original
    NotificationJob.perform_now(question)
  end
end
