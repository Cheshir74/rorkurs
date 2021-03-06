require_relative 'acceptance_helper'

feature 'Create question', %q{
 In order to get answer from community
 As an authentificated user
 I want to be able to ask questions
 } do 
  given(:user) { create(:user) }
  scenario 'authentificated user creates question' do

    sign_in(user)

    visit questions_path
    click_on 'Ask question'
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text'
    click_on 'Create'
    expect(page).to have_content 'Your question successfully created.'
    expect(page).to have_text 'text text'
  end
   
  scenario 'Non-authenticated user ties to create question' do
    visit questions_path
    click_on 'Ask question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
 end