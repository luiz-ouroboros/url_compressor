Rails.application.routes.draw do
  resources :redirections, only: [:create]
  get '/:target_key', to: 'redirections#show'
  delete '/:secret_key', to: 'redirections#destroy'
  get '/history/:secret_key', to: 'redirections#history'
end
