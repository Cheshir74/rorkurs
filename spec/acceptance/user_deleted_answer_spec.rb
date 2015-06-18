require 'rails_helper'

feature 'Delete answer' do 
  given(:user) { create :user }
  given(:otheruser) { create :user }
  given(:question) { create :question, user: user}

  scenario 'autheticated user delete answer' do
    sign_in(user)

    @answer = create :answer, user: user, question: question
    visit question_path(question)
    click_on 'Delete answer'
    expect(page).to_not have_text @answer.body
    expect(current_path).to eq question_path(question)
    

  end

  scenario 'autheticated user try delete answer other user' do
    sign_in(otheruser)

    @answer = create :answer, question: question, user: user
    visit question_path(question)
    expect(page).to have_no_link 'Delete answer'

  end
  scenario 'Guest try delete answer' do

    visit question_path(question)
    expect(page).to have_no_link 'Delete answer'
  end
end