class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_action :callback_hash

  def vkontakte
    @user = User.find_for_oauth(@hash)
    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: 'Vkontakte') if is_navigational_format?
    end
  end

  def facebook
    @user = User.find_for_oauth(@hash)
    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: 'Facebook') if is_navigational_format?
    end
  end

  def twitter
    @user = User.find_for_oauth(@hash)
    if @user and @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: 'Twitter') if is_navigational_format?
    else
      @user = User.new
      session[:auth_provider] = @hash.provider
      session[:auth_uid] = @hash.uid
      render 'omniauth_callbacks/email_confirmation'
    end
  end

  def email_confirmation
    @user = User.generate_user(user_params[:email])
    @user.authorizations.build(provider: session[:auth_provider], uid: session[:auth_uid])
    @user.save
    if @user
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: 'Facebook') if is_navigational_format?
    end
  end


  private

  def user_params
    params.require(:user).permit(:email)
  end

  def callback_hash
    @hash = request.env['omniauth.auth']
  end
end
