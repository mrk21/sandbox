class StrongParametersBypassesController < ApplicationController
  def edit
    @record = User.first
    @record ||= User.create!(name: 'user 1', is_admin: false)
    @is_include_is_admin = params[:is_include_is_admin] == '1'
  end

  def update
    User.update(clean_up_params)
    redirect_to edit_strong_parameters_bypass_path
  end

  private

  def clean_up_params
    valid_params = params.require(:user)
    valid_params.permit!
    valid_columns = %w(name)

    # ActionController::Parameters#each() => Returns not `ActionController::Parameters` but `Hash` (not secure!).
    # Therefore, you must not use the value returned from `ActionController::Parameters#each()`!
    valid_params.each do |key, _|
      valid_params.instance_variable_set(:@permitted, false) unless valid_columns.include?(key)

    end
    # valid_params
  end
end
