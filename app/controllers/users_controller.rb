class UsersController < ApplicationController
  skip_authorization_check

  def finish_signup
    @user = User.new
    @provider = session['devise.oauth.provider']
    @uid = session['devise.oauth.uid']

    if request?
      @user = User.create(email: user_params[:email], password: user_params[:password], password_confirmation: user_params[:password_confirmation])
      if @user.persisted?
        @user.authorizations.create(provider: user_params[:provider], uid: user_params[:uid])
        @user.send_confirmation_instructions
        redirect_to new_user_confirmation_path
      else
        @show_errors = true
      end
    end
  end

  private

  def user_params
    params.require(:user).permit([:email, :password, :password_confirmation, :provider, :uid])
  end
end