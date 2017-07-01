Rails.application.routes.draw do
  resources :urls
  resources :rules
  root 'commits#index'
  resource :github_webhooks, only: :create, defaults: { formats: :json }
  get '/shadow' => 'shadow#index'
  get '/shadow/:id' => 'shadow#show', as: 'request'

  resources :commits
  resources :responses

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
