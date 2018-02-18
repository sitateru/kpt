Rails.application.routes.draw do
  get '/health', to: 'application#health'
  resources :issues
  resources :assignments, only: [:index, :create, :destroy]
  resources :users
end
