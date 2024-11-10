# frozen_string_literal: true

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  resources :sessions, only: [:create]

  resources :users, only: %i[index show create] do
    resources :followings, only: [:index], controller: 'users/followings'
  end

  resources :follows, only: :create

  resources :tweets, only: :create
end
