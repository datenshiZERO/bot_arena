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

  def skip_tutorial
    old_level = current_user.tutorial_level
    current_user.update(tutorial_level: 10)
    redirect_to root_path, notice: (old_level < 7 ? "Tutorial skipped" : nil)
  end

  private

  def user_params
    params.require(:user).permit(:username)
  end
end
