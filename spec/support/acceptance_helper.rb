module AcceptanceHelper
  def sign_in(user)
    visit new_user_session_path 
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Log in'
  end

  def sign_in_facebook
    OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new(
      info: {email: 'test@test.com'},
      provider: 'facebook',
      uid: '123456'
    )
  end

  def sign_in_vkontakte
    OmniAuth.config.mock_auth[:vkontakte] = OmniAuth::AuthHash.new(
      info: {email: 'test@test.com'},
      provider: 'vkontakte',
      uid: '123456'
    )
  end

  def sign_in_twitter
    OmniAuth.config.mock_auth[:twitter] = OmniAuth::AuthHash.new(
      provider: 'twitter',
      uid: '123456'
    )
  end

  def log_out
    page.driver.submit :delete, destroy_user_session_path, {}
  end
end