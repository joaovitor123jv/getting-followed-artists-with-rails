Rails.application.routes.draw do
  # START: API SESSION
  scope '/api' do
    scope '/ping' do
      get '/', to: 'api#ping'
    end
  end

  # END: API SESSION

  get '/auth/:provider/callback', to: "sessions#create" #LOGIN
  delete '/logout', to: 'session#destroy' #LOGOUT


  get 'user/show'
  get 'user/artist_index'

  root 'static_pages#home'
  get '/help', to: 'static_pages#help'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
