class CircumventionOfFileSizeLimitsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def edit
    @record = User.first
    @record ||= User.create!(name: 'user 1')
  end
end
