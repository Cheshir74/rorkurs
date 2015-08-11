require 'rails_helper'

RSpec.describe NotificationJob, type: :job do
  let(:user) { create :user}
  let(:question) {create(:question, user: user)}
  it 'sends notification new answers' do
    expect(Answer).to receive(:send_notification)
    NotificationJob.perform_now(question)
  end
end
