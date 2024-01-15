class User3sController < ApplicationController
  before_action :set_user3, only: %i[ show edit update destroy ]

  # GET /user3s
  def index
    @user3s = User3.all
  end

  # GET /user3s/1
  def show
  end

  # GET /user3s/new
  def new
    @user3 = User3.new
  end

  # GET /user3s/1/edit
  def edit
  end

  # POST /user3s
  def create
    @user3 = User3.new(user3_params)

    if @user3.save
      redirect_to @user3, notice: "User3 was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /user3s/1
  def update
    if @user3.update(user3_params)
      redirect_to @user3, notice: "User3 was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /user3s/1
  def destroy
    @user3.destroy
    redirect_to user3s_url, notice: "User3 was successfully destroyed.", status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user3
      @user3 = User3.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user3_params
      params.require(:user3).permit(:name)
    end
end
