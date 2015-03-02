class UnitTemplatesController < ApplicationController
  before_action :authenticate_user!

  def index
    @units = UnitTemplate::ALL_TEMPLATES
  end

  def show
    @unit = UnitTemplate.find(params[:id])
    raise ActiveRecord::RecordNotFound if @unit.nil?
  end

  def hire
    process_hire(false)
  end

  def hire_equipped
    process_hire(true)
  end

  private

  def process_hire(equipped)
    @template = UnitTemplate.find(params[:id])
    raise ActiveRecord::RecordNotFound if @template.nil?

    if current_user.can_hire?(@template, equipped)

      Unit.transaction do
        @unit = current_user.units.create(template_slug: @template.slug, name: "#{Faker::Name.first_name} #{Faker::Name.last_name}")
        if equipped
          @unit.user_equipments.create(user: current_user, equipment_slug: @template.weapon_default.slug)
          @unit.user_equipments.create(user: current_user, equipment_slug: @template.armor_default.slug)
          @unit.user_equipments.create(user: current_user, equipment_slug: @template.mobility_default.slug)
          current_user.credits -= @template.full_price
        else
          current_user.credits -= @template.price
        end
        @unit.save
        current_user.save
      end
      redirect_to @unit, notice: "Unit hired"
    else
      redirect_to unit_template_path(@template.slug), error: "You cannot hire this unit yet"
    end
  end
end
