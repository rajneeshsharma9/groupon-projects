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
  get '/admin', to: 'admin/deals#index'
  resources :password_resets, only: %i[new create update]
  namespace :admin do
    resources :deals do
      member do
        put 'publish'
        put 'unpublish'
      end
    end
    resources :locations
    resources :collections do
      member do
        put 'publish'
        put 'unpublish'
      end
    end
  end
  resources :deals, only: %i[show]
  resources :orders, only: %i[index] do
    collection do
      get 'cart'
      patch 'update', as: 'update'
      put 'update_cart'
    end
  end
  get '/edit_order', to: 'orders#edit', as: 'edit_order'
  resources :payments, only: %i[create]
end
