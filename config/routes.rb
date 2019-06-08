Rails.application.routes.draw do
  get '/health', to: 'application#health'

  resources :issues do
    member do
      patch :open
      patch :close
    end
  end

  resources :assignments, only: [:index, :create, :destroy]
  resources :tags
  resources :users
end
