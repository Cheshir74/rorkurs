class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_action :callback_hash
  before_action :user_find, except:  :email_confirmation

  def vkontakte
    sing_social(kind: 'Vkontakte')
  end

  def facebook
    sing_social(kind: 'Facebook')
  end

  def twitter
    sing_social(kind: 'Twitter')
  end

  def email_confirmation
    @user = User.generate_user(user_params[:email])
    @user.authorizations.build(provider: session['devise.auth_provider'], uid: session['devise.auth_uid'])
    @user.save
    if @user
      sing_social(kind: 'Twitter')
    end
  end


  private

  def sing_social(kind)
    if @user and @user.persisted?
       sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind) if is_navigational_format?
    else
      @user = User.new
      session['devise.auth_provider'] = @hash.provider
      session['devise.auth_uid'] = @hash.uid
      render 'omniauth_callbacks/email_confirmation'
    end
  end

  def user_find
    @user = User.find_for_oauth(@hash)
  end

  def user_params
    params.require(:user).permit(:email)
  end

  def callback_hash
    @hash = request.env['omniauth.auth']
  end
end
