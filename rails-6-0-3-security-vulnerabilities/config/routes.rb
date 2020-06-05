Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resource :strong_parameters_bypass
  resource :unintended_unmarshalling
  resource :circumvention_of_file_size_limit
  resource :ability_to_forge_per_form_csrf_token
end
