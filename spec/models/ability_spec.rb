require 'rails_helper'

describe Ability do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }

    it { should_not be_able_to :manage, :all }
  end

  describe 'for admin' do
    let(:user) {create :user, admin: true}

    it { should be_able_to :manage, :all}
  end
  describe 'for user' do
    let(:user) {create :user }
    let(:otheruser) {create :user }
    let(:question) { create(:question, user: user) }
    let(:question2) { create(:question, user: otheruser)}
    let(:answer) { create(:answer, question: question, user: otheruser) }
    let(:answer2) { create(:answer, question: question, user: user)}
    let(:answer3) { create(:answer, question: question2, user: otheruser)}
    let(:attachment) { create(:attachment, attachmentable: question) }
    let(:attachment2) { create(:attachment,  attachmentable: question2) }
    let(:vote) { create(:up_vote, user: user, votable: question2) }
    let(:vote2) { create(:up_vote, user: otheruser, votable: question2) }

    it { should_not be_able_to :manage, :all}
    it { should be_able_to :read, :all }

    it { should be_able_to :create, Answer }
    it { should be_able_to :create, Question }
    it { should be_able_to :create, Comment }

    it { should be_able_to :set_best, answer, user: user, best: false }
    it { should_not be_able_to :set_best, answer3, user: otheruser, best: false }

    it { should be_able_to :update, create(:question, user: user), user: user }
    it { should_not be_able_to :update, create(:question, user: otheruser), user: user }
    it { should be_able_to :update, create(:answer, question: question2, user: user), user: user }
    it { should_not be_able_to :update, create(:answer, question: question2, user: otheruser), user: user }
    it { should be_able_to :destroy, create(:question, user: user), user: user }
    it { should_not be_able_to :destroy, create(:question, user: otheruser), user: user }
    it { should be_able_to :destroy, create(:answer, question: question2, user: user), user: user }
    it { should_not be_able_to :destroy, create(:answer, question: question2, user: otheruser), user: user }


    it { should be_able_to :vote_up, question2, user: user}
    it { should be_able_to :vote_up, answer, user: user}
    it { should be_able_to :vote_down, question2, user: user}
    it { should be_able_to :vote_down, answer, user: user}
    it { should be_able_to :vote_destroy, vote, user: user}

    it { should_not be_able_to :vote_up, question, user: user}
    it { should_not be_able_to :vote_up, answer2, user: user}
    it { should_not be_able_to :vote_down, question, user: user}
    it { should_not be_able_to :vote_down, answer2, user: user}
    it { should_not be_able_to :vote_destroy, vote2, user: user}


    it { should be_able_to :destroy, attachment,  user: user}
    it { should_not be_able_to :destroy, attachment2,  user: user}

  end
end