Rails.application.routes.draw do
  get 'session/create'
  get 'session/destroy'
  get 'user/show'
  get 'user/artist_index'
  get 'static_pages/home'
  get 'static_pages/help'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
