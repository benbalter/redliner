RailsAdmin.config do |config|
  config.authenticate_with do
    unless user_signed_in?
      redirect_to main_app.user_omniauth_authorize_path({
        provider: :github,
        origin: main_app.rails_admin_path
      })
    end
  end
  config.authorize_with do
    unless current_user.try(:admin?)
      flash[:error] = "You are not an admin"
      redirect_to main_app.root_uri
    end
  end
  config.current_user_method(&:current_user)

  config.actions do
    dashboard                     # mandatory
    index                         # mandatory
    new
    export
    bulk_delete
    show
    edit
    delete
    show_in_app
  end
end
