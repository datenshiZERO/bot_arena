class BattlesController < ApplicationController
  def index
    @battles = Battle.order("updated_at desc").where("updated_at > ?", DateTime.now - 3.days).includes(:arena).page params[:page]
  end

  def show
    @battle = Battle.includes(:arena, unit_battle_outcomes: { unit: :user}).find(params[:id])
  end
end
