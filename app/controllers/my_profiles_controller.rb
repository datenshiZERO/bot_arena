class MyProfilesController < ApplicationController
  before_action :authenticate_user!

  def show
  end

  def edit
  end

  def update
    if current_user.update_attributes(user_params)
      redirect_to my_profile_path, notice: "Profile updated"
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:username)
  end
end
