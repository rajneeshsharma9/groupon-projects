Rails.application.routes.draw do
  root 'home#index', as: 'home_page'
  resources :users, only: [:new, :create] do
    member do
      get 'dashboard'
    end
  end
  get '/:token/confirm_account/', to: 'users#confirm_account', as: 'confirm_account'
  get '/:token/edit/', to: 'password_resets#edit', as: 'password_reset'
  get '/signup', to: 'users#new', as: 'signup'
  post '/signup', to: 'users#create'
  controller :sessions do
    get  'login' => :new
    post 'login' => :create
    delete 'logout' => :destroy
  end
  resources :password_resets, only: [:new, :create, :update]
end
