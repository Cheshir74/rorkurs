require_relative 'acceptance_helper'

feature 'User delete file from  question' do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:attachment) { create(:attachment, attachmentable: question) }

  describe 'Authenticated user' do

    background do
      sign_in user
    end

    scenario 'User deletes a file from created question', js: true do
      visit question_path(question)
      click_on 'Remove file'

      expect(page).to_not have_link 'Remove file'
      expect(page).to_not have_content attachment.file.identifier

    end
    scenario 'Remove file when created question', js: true do

      visit new_question_path
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text'
      within ('.nested-fields:nth-of-type(1)') do
        attach_file 'Attach file', "#{Rails.root}/spec/spec_helper.rb"
      end
      click_on 'add file'

      within ('.nested-fields:nth-of-type(2)') do
        attach_file 'Attach file', "#{Rails.root}/spec/rails_helper.rb"
      end
      within ('.nested-fields:nth-of-type(1)') do
        click_on 'remove file'
      end

      click_on 'Create'

      expect(page).to have_link 'rails_helper.rb', href: '/uploads/attachment/file/2/rails_helper.rb'

    end
  end

  scenario 'Not author not sees remove file link', js: true do

    visit question_path(question)

    expect(page).to_not have_link 'Remove file'
    expect(page).to have_content attachment.file.identifier
  end
end