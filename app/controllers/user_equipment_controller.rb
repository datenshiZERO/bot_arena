class UserEquipmentController < ApplicationController
  before_action :authenticate_user!

  def index
  end

  def show
  end

  def destroy
    @item = current_user.user_equipment.find(params[:id])
    owner = @item.unit
    if owner.present?
      owner.arena = nil
      owner.save
    end
    current_user.with_lock do
      current_user.credits += @item.price / 2
      current_user.save
    end
    @item.destroy
    redirect_to user_equipment_index_path, notice: "Item sold"
  end
end
