class UnitsController < ApplicationController
  before_action :authenticate_user!, except: :show

  def index
  end

  def show
    @unit = Unit.find(params[:id])
    @outcomes = @unit.unit_battle_outcomes.order("created_at desc").page params[:page]
  end
end
