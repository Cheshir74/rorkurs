require_relative 'acceptance_helper'

feature 'View question and answers' do
  given(:user)  { create :user }
  given(:question) { create :question, user: user }
  given!(:answers) { create_list(:answer, 3, question: question, user: user ) }
  
  scenario 'All can view question and answers' do
    visit question_path(question)
    answers
    expect(answers.count).to eq(3)
    question.answers.each do |answer|
      expect(page).to have_text answer.body
    end
  end
  
end