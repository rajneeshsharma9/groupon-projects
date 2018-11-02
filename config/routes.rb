Rails.application.routes.draw do
  resources :users, only: [:new, :create]
  get '/:token/confirm_email/', to: 'users#confirm_email', as: 'confirm_email'
  get '/signup', to: 'users#new', as: 'signup'
  post '/signup', to: 'users#create'
  root 'home_page#index', as: 'home_page', via: :all
end
