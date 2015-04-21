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

  def begin_speedrun
    current_user.units.each do |unit|
      unit.fired = true
      unit.arena = nil
      unit.user_equipments.each do |e|
        e.unit = nil
        e.save
      end
      unit.save
    end
    current_user.user_equipment.each { |item| item.destroy }
    current_user.update(
      credits: 150,
      total_xp: 0,
      total_missions: 0,
      total_kills: 0,
      stage: 1,
      unlocked_quests: "YNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNN",
      completed_quests: "NNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNN",
      speedrun_start_at: DateTime.now,
      speedrun_end_at: nil
    )
    redirect_to root_path, notice: "Speedrun started. Good luck!"
  end

  private

  def user_params
    params.require(:user).permit(:username)
  end
end
