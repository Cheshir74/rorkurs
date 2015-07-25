require_relative 'acceptance_helper'

feature 'View questions' do
  given(:user) { create :user}
  given!(:questions) { create_list(:question, 3, user: user) }
  
  scenario 'All can view questions' do
    visit questions_path
    
    Question.find_each do |question|
      expect(page).to have_content question.title
    end
  end
  
end 