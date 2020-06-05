class AbilityToForgePerFormCsrfTokensController < ApplicationController
  def edit
    @record = User.first
    @record ||= User.create!(name: 'user 1', is_admin: false)
  end

  def update
    redirect_to edit_ability_to_forge_per_form_csrf_token_path
  end
end
