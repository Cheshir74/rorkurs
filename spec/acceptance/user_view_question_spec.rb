require 'rails_helper'

feature 'View questions' do
  
  given(:questions) { create_list(:question, 3) }
  
  scenario 'All can view questions' do
    visit questions_path
    
    Question.all.each do |question|
      expect(page).to have_text question.title
    end
  end
  
end 