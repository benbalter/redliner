Rails.application.routes.draw do

  get 'welcome/index'
  root "welcome#index"

  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  devise_scope :user do
    get 'sign_out', :to => 'devise/sessions#destroy', :as => :destroy_user_session
  end

  get '/auth/failure' do
    flash[:notice] = params[:message]
    redirect '/'
  end

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

end
