Rails.application.routes.draw do
  get '/health', to: 'application#health'

  resources :issues do
    member do
      patch :open
      patch :close
    end
    resource :tags, controller: 'issue_tags', only: [:show, :update]
  end

  resources :assignments, only: [:index, :create, :destroy]
  resources :tags

  resources :users do
    resource :groups, controller: 'user_groups', only: [:show, :update]
  end

  resources :groups do
    resource :users, controller: 'group_users', only: [:show, :update]
  end
end
