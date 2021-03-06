class EquipmentController < ApplicationController
  before_action :authenticate_user!

  def index
    @items = Equipment::ALL_EQUIPMENT
  end

  def show
    @item = Equipment.find(params[:id])
    raise ActiveRecord::RecordNotFound if @item.nil?
  end

  def buy
    @item = Equipment.find(params[:id])
    raise ActiveRecord::RecordNotFound if @item.nil?
    if current_user.can_buy? @item
      current_user.with_lock do
        current_user.user_equipment.create(equipment_slug: @item.slug)
        current_user.credits -= @item.price
        current_user.save
      end
      redirect_to equipment_index_path, notice: "Equipment bought and added to armory"
    else
      redirect_to equipment_path(@item.slug), alert: "You cannot buy this"
    end
  end
end
