Rails.application.routes.draw do
  namespace :api do
    get 'ratings/index'
    get 'ratings/create'
  end

  get 'welcome/index'

  root 'welcome#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace :api do
    resources :users, only: [:show, :update, :destroy], defaults: {format: :json} do
      resources :questions, only: [:index], defaults: {format: :json}
      resources :answers, only: [:index], defaults: {format: :json}
    end

    resources :user_tags, only: [:index, :create, :destroy]

    resources :questions, only: [:create, :show, :destroy], defaults: {format: :json} do
      resources :answers, only: [:create]
    end

    resources :answers, only: [:show, :update, :destroy], defaults: {format: :json} do
      resources :ratings, only: [:index, :create]
    end

    resources :tags, except: [:edit, :new, :update], defaults: {format: :json}
  end

  post '/login' => 'sessions#create'
  post '/logout' => 'sessions#destroy'

  post '/register' => 'register#create'
end
