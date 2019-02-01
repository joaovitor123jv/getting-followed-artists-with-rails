Rails.application.routes.draw do
  # START: API SESSION

  # END: API SESSION

  get 'session/create'
  get 'session/destroy'

  get '/auth/:provider/callback', to: "sessions#create"

  get 'user/show'
  get 'user/artist_index'

  root 'static_pages#home'
  get 'static_pages/help'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
