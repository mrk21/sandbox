Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'example#ok'
  get '/ok', to: 'example#ok'
  get '/error_404', to: 'example#error_404'
  get '/error_500', to: 'example#error_500'
end
