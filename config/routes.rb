Paperclipfun::Application.routes.draw do
  resources :sessions
  resources :users

  root 'users#index'
end