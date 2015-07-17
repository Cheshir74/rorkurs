require_relative 'acceptance_helper'

feature 'User delete file from answer' do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:answer) { create(:answer, user: user, question: question) }
  given!(:attachment) { create(:attachment, attachmentable: answer) }

  describe 'Authenticated user' do
    background do
      sign_in user
      visit question_path(question)
    end

    scenario 'User deletes a file from created answer', js: true do
      within '.answers' do
        click_on 'Remove file'
        expect(page).to_not have_link 'Remove file'
        expect(page).to_not have_content attachment.file.identifier
      end
    end
    scenario 'Remove file when created answer', js: true do
      fill_in 'Напишите свой ответ', with: 'Test answer'

      within ('.attachment-answers .nested-fields:nth-of-type(1)') do
        attach_file 'Attach file', "#{Rails.root}/spec/spec_helper.rb"
      end
      click_on 'add file'

      within ('.attachment-answers .nested-fields:nth-of-type(2)') do
        attach_file 'Attach file', "#{Rails.root}/spec/rails_helper.rb"
      end

      within ('.attachment-answers .nested-fields:nth-of-type(1)') do
        click_on 'remove file'
      end

      click_on 'Добавить комментарий'

      within '.answers' do
        expect(page).to have_link 'rails_helper.rb', href: '/uploads/attachment/file/1/rails_helper.rb'
      end
    end

  end

  scenario 'Not author not sees remove file link', js: true do
    visit question_path(question)

    within '.answers' do
      expect(page).to_not have_link 'Remove file'
      expect(page).to have_content attachment.file.identifier
    end
  end

end