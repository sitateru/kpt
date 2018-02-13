Rails.application.routes.draw do
  get '/health', to: 'application#health'
  resources :issues
  resources :users
end
