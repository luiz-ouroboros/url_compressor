Rails.application.routes.draw do
  resources :redirections, only: %i[create index]

  get '/:target_key', to: 'redirections#show'
  delete '/:secret_key', to: 'redirections#destroy'
  get '/:secret_key/history', to: 'redirections#history'
end
