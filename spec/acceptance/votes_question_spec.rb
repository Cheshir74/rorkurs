require_relative 'acceptance_helper'

feature 'user can vote for the question of another user' do
  given(:user) {create(:user)}
  given(:otheruser) {create(:user)}
  given!(:question1) {create(:question, user: otheruser)}
  given!(:question2) {create(:question, user: user)}

  scenario "Guest can't see vote links" do
    visit question_path(question1)
    expect(page).to_not have_css '.vote-button'
  end

  scenario "vote UP", js: true do
    sign_in(user)
    visit question_path(question1)
    click_on "+"
    within ".vote-question" do
      expect(page).to have_content "1"
    end
  end

  scenario "vote down", js: true do
    sign_in(user)
    visit question_path(question1)
    click_on "-"
    within ".vote-question" do
      expect(page).to have_content "-1"
    end
  end

  scenario "cancel vote", js: true do
    sign_in(user)
    visit question_path(question1)
    click_on "+"
    click_on "cancel"
    within ".vote-question" do
      expect(page).to have_content "0"
    end
  end

  scenario "Owner Question not vote UP", js: true do
    sign_in(user)
    visit question_path(question2)
    expect(page).to_not have_css '.vote-button'
  end

  scenario "Owner Question vote down", js: true do
    sign_in(user)
    visit question_path(question2)
    expect(page).to_not have_css '.vote-button'
  end

  scenario "Owner Question  cancel vote", js: true do
    sign_in(user)
    visit question_path(question2)
    expect(page).to_not have_css '.vote-button'
  end


end