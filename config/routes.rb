Rails.application.routes.draw do
  devise_for :users
  get "portfolio/index"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "portfolios#index"

  namespace :trader do
    resources :portfolios do
      member do
        patch :sell
      end
    end

  get "my_portfolio", to: "portfolios#my_portfolio", as: :my_portfolio

  resources :transactions, only: [ :index ]
  end

    # Admin routes for managing traders
    namespace :admin do
      resources :users do
        collection do
          get "pending"  # Admin view pending traders
          get "all_traders"   # Admin view all traders
        end
        member do
          patch "approve"  # Admin approves a trader
        end
      end
      # resources :transactions, only: [:index]  # Admin can view all transactions
    end
    namespace :admin do
      resources :transactions, only: [:index]
    end
end