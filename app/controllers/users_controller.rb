class UsersController < ApplicationController
  before_action :set_user, except: %i[ create ]
  before_action :authenticate_user, except: %i[ create status_update ]

  def show
    render json: @user
  end

  def create
    @user = User.new(user_params)

    if @user.save
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def status_update
    @user.update(status: true)
    render json: { message: 'User is now active' }
  end
  
  def update
    if @user.update(user_params)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy!
    render json: { message: 'User deleted' }
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:first_name, :last_name, :email, :password, :dob, phone_numbers: [])
    end
end
