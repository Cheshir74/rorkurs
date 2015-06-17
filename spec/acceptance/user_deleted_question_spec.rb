require 'rails_helper'

feature 'Delete question' do
 
  
  given(:user) { create :user }
  given(:question) { create :question, user: user}
  scenario 'authenticated user delete question' do

    sign_in(user)
    
      
    visit question_path(question)
    click_on 'Delete question'
    expect(current_path).to eq questions_path
    expect(page).to_not have_text question.title
 end
  
  scenario 'authenticated user try delete question  other user' do

    sign_in(user)
    
    @question = create :question 
    visit question_path(@question)
    expect(page).to have_no_link 'Delete question'
  end
  
  scenario 'Guest delete question' do
    
    
    visit question_path(question)
    expect(page).to have_no_link 'Delete question'
 end
  
end 