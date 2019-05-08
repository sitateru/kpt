Rails.application.routes.draw do
  get '/health', to: 'application#health'

  resources :issues do
    member do
      post :open
      post :close
    end
  end

  resources :assignments, only: [:index, :create, :destroy]
  resources :users
end
