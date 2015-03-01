class UnitTemplatesController < ApplicationController
  def index
    @units = UnitTemplate::ALL_TEMPLATES
  end

  def show
    @unit = UnitTemplate.find(params[:id])
    raise ActiveRecord::RecordNotFound if @unit.nil?
  end
end
