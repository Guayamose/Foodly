Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  resources :scans, only: [ :new, :create, :show ] do
    resources :recipes, only: [ :new, :create, :show ]
  end
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
  resources :recipes, only: [:index]
  resources :recipes do
    post :toggle_favorite, on: :member
    post :like, on: :member
  end
  # Defines the root path route ("/")
  # root "posts#index"
end
