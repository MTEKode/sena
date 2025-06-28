Rails.application.routes.draw do
  get "users/new"
  get "users/create"
  devise_for :users, controllers: {
    registrations: 'registrations',
    sessions: 'sessions'
  }

  devise_scope :user do
    get 'login', to: 'sessions#new'
    post 'login', to: 'sessions#create'
    delete 'logout', to: 'sessions#destroy'
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "home#index"

  resources :subscriptions, only: [:index, :new, :create]
  resources :users, only: [:new, :create]
  resources :dashboard, only: [:index]
  resources :chat, only: [:show, :create]
  resources :emoti, only: [:index] do
    collection do
      get 'selection'
    end
  end
  resources :emoti_questions, only: [:index] do
    collection do
      post 'choose_emoti'
    end
  end
end

