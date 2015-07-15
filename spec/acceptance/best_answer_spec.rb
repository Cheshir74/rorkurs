require_relative 'acceptance_helper'

feature 'Select best answer' do
  given(:user) {create :user }
  given(:otheruser) {create :user}
  given!(:question) {create(:question, user: user)}
  given!(:answer1) {create(:answer, question: question, user: otheruser)}
  given!(:answer2) {create(:answer, question: question, user: otheruser)}

  scenario 'Question owner select best answer', js: true do
    sign_in user
    visit question_path(question)

    within("#answer-#{answer1.id}") do
      click_on 'Set best'
    end
    within("#answer-#{answer2.id}") do
      click_on 'Set best'
    end

    within("#answer-#{answer1.id}") do
      expect(page).to_not have_content 'Best Answer'
    end
    within("#answer-#{answer2.id}") do
      expect(page).to have_content 'Best Answer'
    end
  end

  scenario 'Not question owner try select best answer' do
    sign_in otheruser
    visit question_path(question)

    expect(page).to_not have_content 'Set best'
  end
  scenario 'Guest try select best answer' do
    visit question_path(question)

    expect(page).to_not have_content 'Set best'
  end
end

feature 'Best answer - first answer' do
  given(:user) {create :user }
  given(:otheruser) {create :user}
  given!(:question) {create(:question, user: user)}
  given!(:answer1) {create(:answer, question: question, user: otheruser)}
  given!(:answer2) {create(:answer, question: question, user: otheruser)}

  scenario 'user select best answer and sees this first', js: true do
    sign_in user
    visit question_path(question)

    within("#answer-#{answer2.id}") do
      click_on 'Set best'
    end

    within('.answers .answer:first-child') do
      expect(page).to have_content answer2.body
      expect(page).to have_content 'Best Answer'
    end
    within("#answer-#{answer1.id}") do
      click_on 'Set best'
    end

    within('.answers .answer:first-child') do
      expect(page).to have_content answer1.body
      expect(page).to have_content 'Best Answer'
    end
  end
end