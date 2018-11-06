Rails.application.routes.draw do
  root 'home#index', as: 'home_page'
  resources :users, only: [:new, :create] do
    member do
      get 'dashboard'
    end
  end
  get '/:token/confirm_account/', to: 'users#confirm_account', as: 'confirm_account'
  get '/signup', to: 'users#new', as: 'signup'
  post '/signup', to: 'users#create'
  controller :sessions do
    get  'login' => :new
    post 'login' => :create
    delete 'logout' => :destroy
  end
end
