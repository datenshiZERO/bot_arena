class UnitTemplatesController < ApplicationController
  before_action :authenticate_user!

  def index
    @units = UnitTemplate::ALL_TEMPLATES
    if current_user.tutorial_level == 0
      current_user.update(tutorial_level: 1)
    end
  end

  def show
    @unit = UnitTemplate.find(params[:id])
    raise ActiveRecord::RecordNotFound if @unit.nil?
    @dummy_unit = current_user.units.build(template_slug: params[:id], name: "dummy")
    @dummy_unit.user_equipments.build(equipment_slug: @unit.weapon_default.slug)
    @dummy_unit.user_equipments.build(equipment_slug: @unit.armor_default.slug)
    @dummy_unit.user_equipments.build(equipment_slug: @unit.mobility_default.slug)
  end

  def hire
    process_hire(false)
    if current_user.tutorial_level == 1
      current_user.update(tutorial_level: 2)
    end
  end

  def hire_equipped
    process_hire(true)
    if current_user.tutorial_level == 1
      current_user.update(tutorial_level: 3)
    end
  end

  private

  def process_hire(equipped)
    @template = UnitTemplate.find(params[:id])
    raise ActiveRecord::RecordNotFound if @template.nil?

    if current_user.can_hire?(@template, equipped)

      Unit.transaction do
        @unit = current_user.units.create(template_slug: @template.slug, name: "#{Faker::Name.first_name} #{Faker::Name.last_name}")
        current_user.with_lock do
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
      end
      redirect_to @unit, notice: "Unit hired"
    else
      redirect_to unit_template_path(@template.slug), alert: "You cannot hire this unit yet"
    end
  end
end
