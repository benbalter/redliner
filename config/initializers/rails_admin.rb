RailsAdmin.config do |config|

  ### Popular gems integration

  RailsAdmin.config do |config|
    config.authenticate_with do
      warden.authenticate! scope: :user
      unless current_user.try(:admin?)
        flash[:error] = "You are not an admin"
        redirect_to root_path
      end
    end
    config.current_user_method(&:current_user)
  end

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
