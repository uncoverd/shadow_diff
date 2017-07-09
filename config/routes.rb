Rails.application.routes.draw do
  resources :comparison_results
  resources :urls
  root 'commits#index'
  resource :github_webhooks, only: :create, defaults: { formats: :json }
  post '/request/sync' => 'commits#request_sync', as: 'request_sync'
  resources :commits
  resources :responses
  get '/rules/new/:response_id' => 'rules#new', as: 'new_rule'
  post '/rules' => 'rules#create'
  delete '/rules/:id' => 'rules#destroy', as: 'rule_destroy'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
