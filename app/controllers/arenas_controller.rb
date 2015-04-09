class ArenasController < ApplicationController
  before_action :authenticate_user!, only: :update

  def index
    if user_signed_in? && current_user.tutorial_level == 5
      current_user.update(tutorial_level: 6)
    end
    @arenas = Arena.where(active: true).order([:points_max, :points_min]).page params[:page]
  end

  def show
    @arena = Arena.where(active: true).find(params[:id])
  end

  def update
    @arena = Arena.where(active: true).find(params[:id])
    units = current_user.units.where(fired: false).includes(:user_equipments).find(params[:unit_ids])
    Rails.logger.error units - current_user.assignable_units(@arena)
    # if all selected are assignable
    if (units - current_user.assignable_units(@arena)).empty?
      units.each { |u| u.arena = @arena; u.save }
      if current_user.tutorial_level == 6
        current_user.update(tutorial_level: 7)
      end
      redirect_to @arena, notice: "Units assigned"
    else
      redirect_to @arena, alert: "Invalid selection"
    end
  end
end
