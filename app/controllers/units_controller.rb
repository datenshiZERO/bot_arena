class UnitsController < ApplicationController
  before_action :authenticate_user!, except: :show

  def index
  end

  def show
    @unit = Unit.find(params[:id])
    @outcomes = @unit.unit_battle_outcomes.order("created_at desc").page params[:page]
  end

  def destroy
    @unit = Unit.find(params[:id])
    if @unit.user != current_user
      redirect_to root_url, error: "Invalid action"
    else
      @unit.fired = true
      @unit.arena = nil
      @unit.user_equipments.each do |e|
        e.unit = nil
        e.save
      end
      @unit.save
      redirect_to root_url, notice: "Unit fired"
    end
  end
end
