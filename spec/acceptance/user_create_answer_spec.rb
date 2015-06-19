require 'rails_helper'

feature 'Create new answer', %q{
  Only an authenticated user can answer
} do 
  given(:user) { create(:user) }
  given!(:question) { create :question, user: user }

  scenario 'authenticated user create answer', js: true do
    sign_in(user)

    visit question_path(question)
    fill_in 'Напишите свой ответ', with: 'Test answer'
    click_on 'Добавить комментарий'

    expect(current_path).to eq question_path(question)
    within '.answers' do
      expect(page).to have_text 'Test answer'
    end
   end
   scenario 'unautentificated user create answer' do
    visit question_path(question)

    expect(page).to have_no_link 'Create answer on question'
  end
 end
