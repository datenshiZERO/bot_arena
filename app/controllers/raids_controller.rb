class RaidsController < ApplicationController
  before_action :authenticate_user!
  def index
    @raids = current_user.raids.order("created_at desc").includes(:quest).page params[:page]
  end

  def show
    @raid = current_user.raids.find params[:id]
  end

  def create
    @raid = current_user.raids.build raid_params
    if @raid.save
      redirect_to @raid, notice: "Raid completed, see results below"
    else
      @units = current_user.units.where(fired: false, arena: nil).all
      @quests = Quest.includes(:encounters).where(active: true).where("stage <= ?", current_user.stage).order(:stage)
      render :new
    end
  end

  def rerun
    @raid_source = current_user.raids.find params[:id]
    @raid = current_user.raids.build
    @raid.quest = @raid_source.quest
    @raid.unit_1_id = @raid_source.unit_1_id
    @raid.unit_1_front = @raid_source.unit_1_front
    @raid.unit_2_id = @raid_source.unit_2_id
    @raid.unit_2_front = @raid_source.unit_2_front
    @raid.unit_3_id = @raid_source.unit_3_id
    @raid.unit_3_front = @raid_source.unit_3_front
    @raid.unit_4_id = @raid_source.unit_4_id
    @raid.unit_4_front = @raid_source.unit_4_front
    @raid.unit_5_id = @raid_source.unit_5_id
    @raid.unit_5_front = @raid_source.unit_5_front
    @raid.unit_6_id = @raid_source.unit_6_id
    @raid.unit_6_front = @raid_source.unit_6_front
    if @raid.save
      redirect_to @raid, notice: "Raid completed, see results below"
    else
      @units = current_user.units.where(fired: false, arena: nil).all
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
