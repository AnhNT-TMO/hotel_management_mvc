require "sidekiq/web"
Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    root "pages#home"
    get "/baskets", to: "baskets#show"
    post "/payment", to: "payment#create"
    get "/history", to: "histories#show"
    devise_for :users
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
