Rails.application.routes.draw do
  root 'home#index', as: 'home_page'
  resources :users, only: [:new, :create]
  get '/:token/confirm_account/', to: 'users#confirm_account', as: 'confirm_account'
  get '/signup', to: 'users#new', as: 'signup'
  post '/signup', to: 'users#create'
end
