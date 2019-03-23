Rails.application.routes.draw do
  get 'register/create'
  get 'sessions/create'
  get 'sessions/destroy'
  namespace :api do
    get 'tags/index'
    get 'tags/create'
    get 'tags/show'
    get 'tags/destroy'
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace :api do
    resources :users, only: [:show, :update, :destroy], defaults: {format: :json} do
      resources :questions, only: [:index], defaults: {format: :json}
      resources :answers, only: [:index], defaults: {format: :json}
    end
    resources :questions, only: [:create, :show, :destroy], defaults: {format: :json}
    resources :answers, only: [:create, :show, :destroy], defaults: {format: :json}
    resources :tags, except: [:edit, :new, :update], defaults: {format: :json}
  end

  post '/login' => 'sessions#create'
  post '/logout' => 'sessions#destroy'

  post '/register' => 'register#create'
end
