require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should have_many :votes}
  it { should validate_presence_of :title }
  it { should validate_presence_of :body }
  it { should have_many :attachments }
  it { should have_many(:answers).dependent(:destroy).order('best DESC') }
  it { should validate_length_of(:title).is_at_least(5).is_at_most(140) }

  it { should accept_nested_attributes_for :attachments }

  describe "#sum vote" do
    let (:user) {create(:user)}
    let (:question) {create(:question, user: user)}
    let!(:up_list) {create_list(:up_vote, 5, votable: question)}
    let!(:down_list) {create_list(:down_vote, 2, votable: question)}

    it "sum votes  question " do
      expect(question.count_votes).to eq 3
    end
  end
end
