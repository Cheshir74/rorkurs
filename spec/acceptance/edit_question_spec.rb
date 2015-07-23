require_relative 'acceptance_helper'

feature 'question edited' do
  given(:user) { create(:user) }
  given(:otheruser) { create :user }
  given!(:question) { create :question, user: user }

  describe 'Authenticater user' do
    before do
      sign_in user
      visit question_path(question)
    end


    scenario 'sees link to Edit question' do
      expect(page).to have_link "Edit question"
    end


    scenario 'try to edit has question', js: true do
      click_on 'Edit question'

      within "#question-#{question.id}" do
        fill_in "Заголовок", with: 'edited question title'
        fill_in "Ваш вопрос", with: 'edited question'

        click_on 'Save'

        expect(page).to_not have_content 'MyString'
        expect(page).to have_content 'edited question title'

        expect(page).to_not have_content 'MyText'
        expect(page).to have_content 'edited question'
        expect(page).to_not have_selector 'textarea'
      end
    end
  end

  scenario 'Unauthenticated user try to edit question' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit question'
  end

  scenario 'Authenticated user not sees link to edit other user question ' do
    sign_in otheruser
    visit question_path(question)

    expect(page).to_not have_link "Edit question"
  end

end