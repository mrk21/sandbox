class UsersController < ApplicationController
  def index
    render json: User.all.map(&:as_json)
  end
end
