class QuestsController < ApplicationController
  before_action :authenticate_user!
  def index
    @quests = Quest.includes(:encounters).where("stage <= ?", current_user.stage).order(:stage)
  end

  def show
    @quest = Quest.includes(:encounters).find params[:id]
    if @quest.stage > current_user.stage
      redirect_to quests_path, alert: "You have not unlocked this stage yet"
    end
    @raid = @quest.raids.build()
    @units = current_user.units.where(fired: false, arena: nil).all
  end
end
