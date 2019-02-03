Rails.application.routes.draw do
  # START: API SESSION
  scope '/api' do
    scope '/login' do
      post '/', to: 'api#login_post'
    end
    scope '/v1' do
      scope '/authorize-spotify' do
        get '/', to: 'api#authorize_spotify'
      end
      scope '/callback' do
        get '/', to: 'api#callback'
      end
      scope '/get-user-artists' do
        get '/', to: 'api#get_user_artists'
      end
      scope '/ping' do
        get '/', to: 'api#ping'
      end
    end
  end

  # END: API SESSION

  get '/auth/:provider/callback', to: "session#create" #LOGIN
  delete '/logout', to: 'session#destroy' #LOGOUT


  get 'user/show'
  get 'user/artist_index'

  root 'static_pages#home'
  get '/help', to: 'static_pages#help'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
