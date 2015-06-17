require 'rails_helper'

feature 'View question and answers' do
  
  given(:question) { create :question }
  given(:answers) { create_list(:answer, 3, question: question) }
  
  scenario 'All can view question and answers' do
    visit question_path(question)
    question.answers.all.each do |answer|
      expect(page).to have_text answer.body
    end
  end
  
end