class QuestsController < ApplicationController
  before_action :authenticate_user!
  def index
    @areas = Area.all
  end

  def show
    @quest = Quest.find params[:id]

    if current_user.unlocked_quest?(@quest)
      @raid = Raid.new(quest_id: @quest.stage)
      @units = current_user.units.where(fired: false, arena: nil).all
    else
      redirect_to quests_path, alert: "You have not unlocked this stage yet"
    end
  end
end
