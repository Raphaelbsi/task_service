require 'sidekiq/web'

Rails.application.routes.draw do
  resources :tasks
  root to: 'tasks#index'

  mount Sidekiq::Web => '/sidekiq'
end
