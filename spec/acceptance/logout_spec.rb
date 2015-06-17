require 'rails_helper'
feature 'User log out' do 
  given(:user) { create(:user) }

  scenario 'Autenticated user log out' do

    sign_in(user)

    expect(current_path).to eq root_path
    log_out
    expect(page).to have_content "Signed out successfully"
  end
  
end