class PagesController < ApplicationController
  before_action :authenticate_user!, except: [:index, :help, :leaderboard]
  def index
    @latest_battles = Battle.order("updated_at desc").includes(:arena).limit 5
  end

  def dashboard
  end

  def my_battles
    @outcomes = UnitBattleOutcome.joins(unit: :user).includes(:unit, battle: :arena).where("users.id = ?", current_user.id).order("created_at desc").page params[:page]
  end

  def leaderboard
    @top_ten = User.where(leaderboard_visible: true).order("total_trophies DESC").limit(10)
  end
end
