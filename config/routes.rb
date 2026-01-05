Rails.application.routes.draw do

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  # Root path
  root 'dashboard#index'

  # Dashboard
  get 'dashboard', to: 'dashboard#index'

  # Admin resources
  resources :tiers
  resources :users do
    member do
      get :points
    end
  end
  resources :campaigns
  resources :malls
  resources :categories
  resources :shops do
    member do
      get :analytics
      patch :approve
      patch :activate
      patch :deactivate
    end
    resources :shop_admins, only: [:create, :destroy]
  end

  resources :transactions
  resources :mall_admins
  resources :shop_admins
  resources :earn_transactions
  resources :redeem_transactions
  resources :offers

  resources :stamps
  # resources :user_stamp_cards
  # resources :stamp_transactions
  resources :audit_logs
  
  resources :points, only: [:index] do
    collection do
      post :update_rules
    end
  end

  resources :configurations, only: [:index] do
    collection do
      patch :update, as: :update
    end
  end

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
  # Devise Authentication
  devise_for :mall_admins, path: 'mall_admin', controllers: {
    sessions: 'mall_admins/sessions',
    registrations: 'mall_admins/registrations'
  }
  devise_for :shop_admins, path: 'shop_admin', controllers: {
    sessions: 'shop_admins/sessions',
    registrations: 'shop_admins/registrations'
  }

  # Shop Admin Namespaced Routes
  namespace :shop_admins, path: 'shop_admin' do
    root 'dashboard#index'
    resources :offers do
      member do
        patch :activate
        patch :deactivate
      end
    end
    resources :stamps do
      member do
        patch :activate
        patch :deactivate
      end
    end
    resources :redemptions, only: [:index, :new, :create]
    resource :shop, only: [:show, :edit, :update] do
      patch :activate
      patch :deactivate
    end
  end

  # Profile (For authenticated user - Devise handles this via registrations#edit)
  # Keeping custom profile for compatibility, but Devise's edit registration is preferred

  # Define specific root for authenticated users if needed, or stick to dashboard
end
