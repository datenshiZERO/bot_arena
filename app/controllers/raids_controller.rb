class RaidsController < ApplicationController
  before_action :authenticate_user!
  def index
  end

  def show
    @raid = current_user.raids.find params[:id]
  end

  def create
    @raid = current_user.raids.build raid_params
    if @raid.save!
      redirect_to @raid, notice: "Raid completed, see results below"
    else
      @units = current_user.units.where(fired: false, arena: nil).all
      @quest = Quest.find @raid.quest_id
      @quests = Quest.includes(:encounters).where("stage <= ?", current_user.stage).order(:stage)
      render :new
    end
  end

  private

  def raid_params
    params.require(:raid).permit(:quest_id, :unit_1_id, :unit_1_front,
                                 :unit_2_id, :unit_2_front, :unit_3_id,
                                 :unit_3_front, :unit_4_id, :unit_4_front,
                                 :unit_5_id, :unit_5_front, :unit_6_id, 
                                 :unit_6_front)
  end
end
