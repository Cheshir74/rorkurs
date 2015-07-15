require_relative 'acceptance_helper'

feature 'Answer editing', %q{
  In order to fix mistake
  As an author of answer
  I'd like to be able to edit my answer
} do
  given(:user) { create(:user) }
  given(:otheruser) { create :user }
  given!(:question) { create :question, user: user }
  given!(:answer) { create :answer, question: question, user: user  }

  scenario 'Unauthenticated user try to edit question' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticater user' do
    before do
      sign_in user
      visit question_path(question)
    end


    scenario ' sees link to Edit' do
      within '.answers' do
        expect(page).to have_link "Edit"
      end
    end


    scenario 'try to edit has answer', js: true do
      click_on 'Edit'
      within '.answers' do
        fill_in "Ваш ответ", with: 'edited answer'
        click_on 'Save'

      expect(page).to_not have_content 'Test answer'
      expect(page).to have_content 'edited answer'
      expect(page).to_not have_selector 'textarea'
        end
    end
  end


  scenario 'Authenticated user not sees link to edit other user question ' do
    sign_in otheruser
    answer
    visit question_path(question)

    within '.answers' do
      expect(page).to_not have_link "Edit"
    end
  end
end