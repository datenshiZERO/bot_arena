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
      if current_user.raids.count > 0
        last_raid = current_user.raids.last
        @raid.unit_1_id = last_raid.unit_1_id
        @raid.unit_1_front = last_raid.unit_1_front
        @raid.unit_2_id = last_raid.unit_2_id
        @raid.unit_2_front = last_raid.unit_2_front
        @raid.unit_3_id = last_raid.unit_3_id
        @raid.unit_3_front = last_raid.unit_3_front
        @raid.unit_4_id = last_raid.unit_4_id
        @raid.unit_4_front = last_raid.unit_4_front
        @raid.unit_5_id = last_raid.unit_5_id
        @raid.unit_5_front = last_raid.unit_5_front
        @raid.unit_6_id = last_raid.unit_6_id
        @raid.unit_6_front = last_raid.unit_6_front
      end
    else
      redirect_to quests_path, alert: "You have not unlocked this quest yet"
    end
  end
end
