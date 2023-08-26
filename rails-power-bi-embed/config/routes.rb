Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "power_bi_reports#show"
  get 'power_bi_reports/embed_data', to: 'power_bi_reports#embed_data'
end
