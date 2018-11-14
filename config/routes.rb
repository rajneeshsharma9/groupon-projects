Rails.application.routes.draw do
  root 'home#index', as: 'home_page'
  resources :users, only: %i[new create]
  get '/:token/confirm_account/', to: 'users#confirm_account', as: 'confirm_account'
  get '/:token/edit/', to: 'password_resets#edit', as: 'password_reset'
  get '/signup', to: 'users#new', as: 'signup'
  post '/signup', to: 'users#create'
  controller :sessions do
    get  'login' => :new
    post 'login' => :create
    delete 'logout' => :destroy
  end
  resources :password_resets, only: %i[new create update]
  namespace :admin do
    #resources for deals will go here
  end
end
