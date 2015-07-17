require_relative 'acceptance_helper'

feature 'Add files to answer', %q{
 In order to illustrate my answer
  As an answer's author
  I'd like to be able to attach files
} do

  given(:user) { create(:user)}
  given(:question) { create(:question, user: user)}

  background do
    sign_in(user)
    visit question_path(question)
  end

  scenario 'User adds file when asks answers', js: true do
    fill_in 'Напишите свой ответ', with: 'Test answer'

    attach_file 'Attach file', "#{Rails.root}/spec/spec_helper.rb"
    click_on 'Добавить комментарий'

    within '.answers' do
      expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
    end
  end

  scenario 'User adds few file when asks answers', js: true do
    fill_in 'Напишите свой ответ', with: 'Test answer'
    within ('.attachment-answers .nested-fields:nth-of-type(1)') do
      attach_file 'Attach file', "#{Rails.root}/spec/spec_helper.rb"
    end
    click_on 'add file'

    within ('.attachment-answers .nested-fields:nth-of-type(2)') do
      attach_file 'Attach file', "#{Rails.root}/spec/rails_helper.rb"
    end
    click_on 'Добавить комментарий'

    within '.answers' do
      expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
      expect(page).to have_link 'rails_helper.rb', href: '/uploads/attachment/file/2/rails_helper.rb'
    end
  end
end