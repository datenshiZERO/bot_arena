class PagesController < ApplicationController
  before_action :authenticate_user!, except: [:index, :help]
  def index
    @latest_battles = Battle.order("updated_at desc").includes(:arena).limit 5
  end

  def dashboard
  end

  def my_battles
    @outcomes = UnitBattleOutcome.joins(unit: :user).includes(battle: :arena).where("users.id = ?", current_user.id).order("created_at desc").page params[:page]
  end
end
