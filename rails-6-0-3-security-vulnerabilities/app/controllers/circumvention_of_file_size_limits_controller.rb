class CircumventionOfFileSizeLimitsController < ApplicationController
  def edit
    @record = User.first
    @record ||= User.create!(name: 'user 1')
  end

  def update
    @record = User.first
    @record.assign_attributes(update_params)
    @record.save!
    redirect_to edit_circumvention_of_file_size_limit_path
  end

  private

  def update_params
    params.require(:user).permit(:avatar)
  end
end
