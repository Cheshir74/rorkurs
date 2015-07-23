require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should have_many :votes}
  it { should validate_presence_of :title }
  it { should validate_presence_of :body }
  it { should have_many :attachments }
  it { should have_many(:answers).dependent(:destroy).order('best DESC') }
  it { should validate_length_of(:title).is_at_least(5).is_at_most(140) }
  it { should have_many :comments}

  it { should accept_nested_attributes_for :attachments }

  describe "#sum vote" do
    let (:user) {create(:user)}
    let (:user1) {create(:user)}
    let (:user2) {create(:user)}
    let (:user3) {create(:user)}
    let (:question) {create(:question, user: user)}
    let!(:up) {create(:up_vote, votable: question, user: user)}
    let!(:down) {create(:down_vote, votable: question, user: user1)}
    let!(:up2) {create(:up_vote, votable: question, user: user2)}
    let!(:up3) {create(:up_vote, votable: question, user: user3)}

    it "sum votes  question " do
      expect(question.count_votes).to eq 2
    end
  end
end
