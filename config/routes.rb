Rails.application.routes.draw do
  resources :comparison_results
  resources :urls
  resources :rules
  root 'commits#index'
  resource :github_webhooks, only: :create, defaults: { formats: :json }
  post '/request/sync' => 'commits#request_sync', as: 'request_sync'
  resources :commits
  resources :responses

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
