require_relative 'acceptance_helper'

feature 'Omniauth sign in' do

  background { OmniAuth.config.test_mode = true }

  scenario 'Sign in with facebook' do
    sign_in_facebook

    visit new_user_session_path
    click_on 'Sign in with Facebook'

    within '.notice' do
      expect(page).to have_content 'Successfully authenticated from Facebook account.'
    end
  end

  scenario 'Sign in with vkontakte' do
    sign_in_vkontakte

    visit new_user_session_path
    click_on 'Sign in with Vkontakte'

    within '.notice' do
      expect(page).to have_content 'Successfully authenticated from Vkontakte account.'
    end
  end

  scenario 'sign in with twitter' do
    sign_in_twitter

    visit new_user_session_path
    click_on 'Sign in with Twitter'

    fill_in 'Введите свой email', with: 'test@test.com'
    click_on 'Отправить'

    open_email 'test@test.com'
    current_email.click_link 'Confirm my account'
    clear_emails

    expect(page).to have_content 'Your email address has been successfully confirmed.'
    click_on 'Sign in with Twitter'

    within '.notice' do
      expect(page).to have_content 'Successfully authenticated from Twitter account.'
    end
  end
end