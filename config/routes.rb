Rails.application.routes.draw do
  get '/:target_key', to: 'redirections#show'
  delete '/:secret_key', to: 'redirections#destroy'
  get '/:secret_key/history', to: 'redirections#history'

  resources :redirections, only: %i[create index]
end
