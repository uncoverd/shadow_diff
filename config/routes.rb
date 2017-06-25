Rails.application.routes.draw do
  root 'shadow#index'
  resource :github_webhooks, only: :create, defaults: { formats: :json }
  get '/shadow' => 'shadow#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
