class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      # guard against the session-fixation attacks:
      reset_session
      # log in new users automatically as part of the signup process:
      log_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      render 'new', status: :unprocessable_entity
    end
  end

  private 
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
end
