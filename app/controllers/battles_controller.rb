class BattlesController < ApplicationController
  before_action :authenticate_user!, only: :retain
  
  def index
    @battles = Battle.order("updated_at desc").where("updated_at > ?", DateTime.now - 3.hours).includes(:arena).page params[:page]
  end

  def show
    @has_share = true
    @battle = Battle.includes(:arena, unit_battle_outcomes: { unit: :user}).find(params[:id])
  end
  
  def retain
    @battle = Battle.find(params[:id])
    @battle.retain = true
    @battle.save
    redirect_to @battle, notice: "Battle record marked to prevent deletion"
  end
end
