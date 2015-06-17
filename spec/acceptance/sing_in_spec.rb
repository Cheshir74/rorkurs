require 'rails_helper'

feature 'User sign in', %q{
   In oreder to be able to ask question 
   As an user 
   I want to be able to sing in 
} do 
  given(:user) { create(:user) }
  scenario 'Registered user try to sing in' do

    sign_in(user)

     expect(page).to have_content 'Signed in successfully.'
     expect(current_path).to eq root_path
  end

  scenario 'Non-regustered user try to sing in' do
    visit new_user_session_path 
    fill_in 'Email', with: 'error@user.com'
    fill_in 'Password', with: '124214214'
    click_on 'Log in'

    expect(page).to have_content 'Invalid email or password.'
    expect(current_path).to eq new_user_session_path
  end
end