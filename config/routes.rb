Rails.application.routes.draw do

  root "home#show"

  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  resources :redlines
  resources :documents
  resources :repositories
  resources :users

  devise_scope :user do
    get 'sign_out', :to => 'devise/sessions#destroy', :as => :destroy_user_session
  end

  get '/auth/failure' do
    flash[:notice] = params[:message]
    redirect '/'
  end

end
