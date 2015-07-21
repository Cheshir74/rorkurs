require_relative 'acceptance_helper'

feature 'user can vote for the answer of another user' do
  given (:user) {create(:user)}
  given (:otheruser) {create(:user)}
  given!(:question) {create(:question, user: user)}
  given (:answer) {create(:answer, question: question, user: otheruser)}
  given (:answer2) {create(:answer, question: question, user: user)}

  scenario "Guest can't see vote links" do
    visit question_path(question)
    expect(page).to_not have_css '.vote-button'
  end

  scenario "vote UP", js: true do
    answer
    sign_in(user)
    visit question_path(question)

    within ".answers" do
      click_on "+"
      expect(page).to have_content "1"
      expect(page).to_not have_link '+'
      expect(page).to have_link 'cancel'
    end
  end

  scenario "Vote down", js: true do
    answer
    sign_in(user)
    visit question_path(question)

    within ".answers" do
      click_on "-"
      expect(page).to have_content "-1"
      expect(page).to_not have_link '-'
      expect(page).to have_link 'cancel'
    end

  end

  scenario "cancel vote", js: true do
    answer
    sign_in(user)
    visit question_path(question)

    within ".answers" do
      click_on "+"
      click_on "cancel"
      expect(page).to have_content "0"
      expect(page).to_not have_link 'cancel'
    end
  end

  scenario "Owner answer vote UP", js: true do
    answer2
    sign_in(user)
    visit question_path(question)

    within ".answers" do
      expect(page).to_not have_css '.vote-button'
    end
  end

  scenario "Owner answer Vote down", js: true do
    answer2
    sign_in(user)
    visit question_path(question)

    within ".answers" do
      expect(page).to_not have_css '.vote-button'
    end

  end

  scenario "Owner answer cancel vote", js: true do
    answer2
    sign_in(user)
    visit question_path(question)

    within ".answers" do
      expect(page).to_not have_css '.vote-button'
    end
  end
end