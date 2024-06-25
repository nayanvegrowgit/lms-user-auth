
Rails.application.routes.draw do
  devise_for :users, path: '', path_names: {
    sign_in: 'login',
    sign_out: 'logout',
    registration: 'signup'
  },
  controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }
  namespace :admin do
    resources :librarians, only: [:index, :create, :destroy]
  end
  post '/auth_controller', to: 'auth#is_verified_token'
end