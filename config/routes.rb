Rails.application.routes.draw do
  require 'sidekiq/web'
  require 'sidekiq/cron/web'

  resources :comparison_results
  resources :urls
  root 'commits#index'
  resource :github_webhooks, only: :create, defaults: { formats: :json }
  post '/request/sync' => 'commits#request_sync', as: 'request_sync'
  resources :commits do
    resources :urls do
      resources :responses
    end  
  end  
  get '/rules/new/:response_id' => 'rules#new', as: 'new_rule'
  post '/rules' => 'rules#create'
  delete '/rules/:id' => 'rules#destroy', as: 'rule_destroy'
  post '/commits/:commit_id/urls/:url_id/responses/:id/override' => 'responses#override_response', as: 'override_response'
  post '/commits/:commit_id/urls/:url_id/override' => 'responses#override_url_response', as: 'override_url_response'

  mount Sidekiq::Web => '/sidekiq'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
