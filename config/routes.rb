Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace :api do
    resources :users, only: [:show, :update, :destroy] do
      resources :questions, only: [:index]
      resources :answers, only: [:index]
    end
    resources :questions, only: [:create, :show, :destroy]
    resources :answers, only: [:create, :show, :destroy]
    resources
    resources :tags, except: [:edit, :new, :update]
  end

  post '/login' => 'sessions#create'
  post '/logout' => 'sessions#destroy'

  post '/register' => 'register#create'
end
