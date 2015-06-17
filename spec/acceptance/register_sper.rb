require 'rails_helper'

feature 'register' do 
  given(:user) { create(:user)}

  scenario 'guest registered' do
    visit new_user_registration_path
    fill_in 'Password', with: user.password
    fill_in 'Password confirmation', with: user.password
    click_on 'Sign up'
    expect(current_path).to eq root_path
  end

  scenario 'Guest try to register with already used email' do

    visit new_user_registration_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    fill_in 'Password confirmation', with: user.password
    click_on 'Sign up'
    expect(page).to have_content 'Email has already been taken'

  end
end