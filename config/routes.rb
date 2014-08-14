Paperclipfun::Application.routes.draw do
	get 'signup', to: 'users#new', as: 'signup'
	get 'login', to: 'sessions#new', as: 'login'
	get 'logout', to: 'sessions#destroy', as: 'logout'

	resources :sessions
	resources :photos
	resources :users

	root 'users#index'
end
