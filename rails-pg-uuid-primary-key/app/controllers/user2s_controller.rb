class User2sController < ApplicationController
  before_action :set_user2, only: %i[ show edit update destroy ]

  # GET /user2s
  def index
    @user2s = User2.all
  end

  # GET /user2s/1
  def show
  end

  # GET /user2s/new
  def new
    @user2 = User2.new
  end

  # GET /user2s/1/edit
  def edit
  end

  # POST /user2s
  def create
    @user2 = User2.new(user2_params)

    if @user2.save
      redirect_to @user2, notice: "User2 was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /user2s/1
  def update
    if @user2.update(user2_params)
      redirect_to @user2, notice: "User2 was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /user2s/1
  def destroy
    @user2.destroy
    redirect_to user2s_url, notice: "User2 was successfully destroyed.", status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user2
      @user2 = User2.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user2_params
      params.require(:user2).permit(:name)
    end
end
