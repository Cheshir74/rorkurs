require 'acceptance/acceptance_helper.rb'

feature 'Add comment to answer' do

  given(:user) {create(:user)}
  given!(:question) {create(:question, user: user)}
  given!(:answer)   {create(:answer, question: question, user: user)}

  scenario "User add comment to answer", js: true do
    sign_in(user)
    visit question_path(question)
    within ".answers" do
      click_on "Add comment"
      fill_in "Comment", with: "I'am can create comment to answer!"
      click_on 'Create'
      expect(page).to have_content "I'am can create comment to answer!"
    end
  end
  scenario "Guest not sees link add comment to question" do
    visit question_path(question)
    within ".answers" do
      expect(page).to_not have_link "Add comment"
    end
  end

end