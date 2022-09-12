require "sidekiq/web"
Rails.application.routes.draw do
  devise_for :users, only: :omniauth_callbacks, controllers: {omniauth_callbacks: "users/omniauth_callbacks"}
  scope "(:locale)", locale: /en|vi/ do
    root "pages#home"
    get "/baskets", to: "baskets#show"
    post "/payment", to: "payment#create"
    get "/history", to: "histories#show"
    delete "/delete", to: "baskets#destroy"
    devise_for :users, skip: :omniauth_callbacks
    as :user do
      get "/login", to: "devise/sessions#new"
      post "/login", to: "devise/sessions#create"
      delete "/logout", to: "devise/sessions#destroy"
    end
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
  mount Sidekiq::Web, at: "/sidekiq"
end
