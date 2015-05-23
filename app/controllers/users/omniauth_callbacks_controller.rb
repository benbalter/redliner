class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    session[:token] = request.env["omniauth.auth"].credentials.token
    @user = User.from_omniauth(request.env["omniauth.auth"])
    sign_in_and_redirect @user, :event => :authentication
    set_flash_message(:notice, :success, :kind => "GitHub") if is_navigational_format?
  end
end
