Rails.application.routes.draw do
  resources :users, only: :index
  root to: 'root#index'
end
