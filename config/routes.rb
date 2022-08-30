require 'sidekiq/web'
Rails.application.routes.draw do
  get 'reviews/new'
  get 'reviews/create'
  get 'histories/show'
  scope "(:locale)", locale: /en|vi/ do
    root "pages#home"
    get "/login", to: "sessions#new"
    post "/login", to: "sessions#create"
    delete "/logout", to: "sessions#destroy"
    get "/baskets", to: "baskets#show"
    post "/payment", to: "payment#create"
    get "/history", to: "histories#show"
    resources :users
    namespace :admin do
      resources :dashboard
      resources :rooms
      resources :bills do
        resources :bookings
      end
    end
    resources :rooms
    resources :bookings
    resources :baskets
    resources :reviews, only: %i(new create)
  end
  mount Sidekiq::Web, at: '/sidekiq'
end
