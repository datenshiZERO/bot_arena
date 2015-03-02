class UnitsController < ApplicationController
  before_action :authenticate_user!, except: :show

  def index
    redirect_to root_url
  end

  def show
    @unit = Unit.find(params[:id])
    @outcomes = @unit.unit_battle_outcomes.order("created_at desc").page params[:page]
  end

  def edit
    @unit = current_user.units.where(fired: false).find(params[:id])
    @unit.setup_equipment_ids
    @weapons = ([@unit.weapon] +
      current_user.user_equipment.where(unit: nil).all.select { |e| e.slot == "weapon" && e.points <= @unit.unit_template.weapon_points }).compact
    @armor =  ([@unit.armor] +
      current_user.user_equipment.where(unit: nil).all.select { |e| e.slot == "armor" && e.points <= @unit.unit_template.armor_points }).compact
    @mobility = ([@unit.mobility_item] +
      current_user.user_equipment.where(unit: nil).all.select { |e| e.slot == "mobility" && e.points <= @unit.unit_template.mobility_points }).compact
  end

  def update
    @unit = current_user.units.where(fired: false).find(params[:id])
    if @unit.update_attributes(unit_params)
      @unit.update_equipment
      redirect_to @unit, notice: "Unit updated"
    else
      @weapons = ([@unit.weapon] +
        current_user.user_equipment.where(unit: nil).all.select { |e| e.slot == "weapon" && e.points <= @unit.unit_template.weapon_points }).compact
      @armor =  ([@unit.armor] +
        current_user.user_equipment.where(unit: nil).all.select { |e| e.slot == "armor" && e.points <= @unit.unit_template.armor_points }).compact
      @mobility = ([@unit.mobility_item] +
        current_user.user_equipment.where(unit: nil).all.select { |e| e.slot == "mobility" && e.points <= @unit.unit_template.mobility_points }).compact
      render :edit
    end
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

  private

  def unit_params
    params.require(:unit).permit(:name, :weapon_id, :armor_id, :mobility_id)
  end
end
