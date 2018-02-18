Rails.application.routes.draw do
  get '/health', to: 'application#health'
  resources :issues do
    resources :assignments, only: [:index, :create, :destroy]
  end
  resources :users
end
