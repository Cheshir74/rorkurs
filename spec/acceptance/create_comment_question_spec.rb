require 'acceptance/acceptance_helper.rb'

feature 'Add comment to question' do

  given(:user) {create(:user)}
  given!(:question) {create(:question, user: user)}

  scenario "User add comment to question", js: true do
    sign_in(user)
    visit question_path(question)
    within ".question .comments" do
      click_on "Add comment"
      fill_in "Comment", with: "I'am can create comment to question!"
      click_on 'Create'
      expect(page).to have_content "I'am can create comment to question!"
    end
  end

  scenario "Guest not sees link add comment to question" do
    visit question_path(question)
    within ".question .comments" do
      expect(page).to_not have_link "Add comment"
    end
  end

end