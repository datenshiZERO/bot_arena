class BattlesController < ApplicationController
  def index
    @battles = Battle.order("updated_at desc").includes(:arena).page params[:page]
  end

  def show
    @battle = Battle.find(params[:id])
  end
end
