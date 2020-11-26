Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'home#index'

  # get "/home", to: "home#index"
  resources :home, only: :index

  # get "/login", to: "sessions#new"
  # post '/login', to: "sessions#create"
  resources :login, only: [:new, :create], controller: :sessions, path_names: { new: '' }
  # delete '/logout', to: 'sessions#destroy'
  resource :logout, only: :destroy, controller: :sessions

  # get "/merchants", to: "merchants#index"
  # get "/merchants/new", to: "merchants#new"
  # get "/merchants/:id", to: "merchants#show"
  # post "/merchants", to: "merchants#create"
  # get "/merchants/:id/edit", to: "merchants#edit"
  # patch "/merchants/:id", to: "merchants#update"
  # delete "/merchants/:id", to: "merchants#destroy"
  resources :merchants

  # get "/items", to: "items#index"
  # get "/items/:id", to: "items#show"
  # get "/items/:id/edit", to: "items#edit"
  # patch "/items/:id", to: "items#update"
  # get "/merchants/:merchant_id/items", to: "items#index"
  # get "/merchants/:merchant_id/items/new", to: "items#new"
  # post "/merchants/:merchant_id/items", to: "items#create"
  # delete "/items/:id", to: "items#destroy"

  # get "/items/:item_id/reviews/new", to: "reviews#new"
  # post "/items/:item_id/reviews", to: "reviews#create"
  resources(:items, only: [:index, :show, :edit, :update, :destroy]) do
    resources :reviews, only: [:new, :create]
  end

  resources :merchants do
    resources :items, only: [:index, :new, :create]
  end

  get "/reviews/:id/edit", to: "reviews#edit"
  patch "/reviews/:id", to: "reviews#update"
  delete "/reviews/:id", to: "reviews#destroy"

  post "/cart/:item_id", to: "cart#add_item"
  get "/cart", to: "cart#show"
  delete "/cart", to: "cart#empty"
  delete "/cart/:item_id", to: "cart#remove_item"
  patch "/cart/:item_id/increase", to: "cart#increase_item"
  patch "/cart/:item_id/decrease", to: "cart#decrease_item"

  get "/orders/new", to: "orders#new"
  post "/orders", to: "orders#create"
  get "/orders/:id", to: "orders#show"

  get "/register", to: "users#new"
  post "/register", to: "users#create"

  get "/profile", to: "users#show"

  get "/profile/orders", to: "orders#index"
  get "/profile/orders/:id", to: "orders#show"
  patch "/profile/orders/:id", to: "orders#update"

  get "/profile/edit", to: "users#edit"
  patch "/profile/edit", to: "users#update"
  get "/profile/edit/password", to: "users#edit_password"
  patch "/profile/edit/password", to: "users#update_password"

  namespace :merchant do
    get "/", to: "dashboard#index"
    get "/items", to: "items#index"
    get "/orders/:id", to: "orders#show"
    patch "/orders/:id", to: "orders#update"
    patch "/items", to: "items#update"
    get "/items/new", to: "items#new"
    post "/items", to: "items#create"
    delete "/items", to: "items#destroy"
    get "/items/:id/edit", to: "items#edit"
    patch "/items/:id/edit",to: "items#edit_update"
  end

  namespace :admin do
    get "/", to: "dashboard#index"
    get "/users", to: "users#index"
    get "/users/:user_id", to: "users#show"
    get "/merchants", to: "merchants#index"
    get "/merchants/:id", to: "merchants#show"
    patch "/merchants/:merchant_id/disable", to: "merchants#disable"
    patch "/merchants/:merchant_id/enable", to: "merchants#enable"
    get "/merchants/:merchant_id/items", to: "items#index"
    patch "/orders/:order_id", to: "orders#update"
  end
end
