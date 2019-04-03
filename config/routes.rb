Rails.application.routes.draw do
  namespace :api do
    get 'question_tags/index'
  end
  namespace :api do
    get 'verify_token/create'
  end
  namespace :api do
    get 'password_resets/create'
    get 'password_resets/update'
  end
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
      resources :answers, only: [:index, :create]
      resources :tags, only: [:index]
    end

    resources :answers, only: [:show, :update, :destroy], defaults: {format: :json} do
      resources :ratings, only: [:index, :create]
    end

    resources :tags, except: [:edit, :new, :update], defaults: {format: :json}

    resources :password_resets, only: [:create, :update]
    resources :verify_token, only: [:create]
  end

  post '/login' => 'sessions#create'
  post '/logout' => 'sessions#destroy'

  post '/register' => 'register#create'
end
