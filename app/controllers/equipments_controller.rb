class EquipmentsController < ApplicationController
  before_action :set_equipment, only: %i[update destroy]

  deserializable_resource :equipment, only: %i[create update destroy]

  # GET /equipments
  # Returns the sections (Shields, Weapons)
  def index
    sections = %w[Shields Weapons]
    render json: { data: sections }
  end

  # GET /equipments/shields
  # Returns all shields
  def shields
    shields = Equipment.where(equipment_type: 'Shield')
    render json: EquipmentSerializer.new(shields).serializable_hash.to_json
  end

  # GET /equipments/weapons
  # Returns all weapons
  def weapons
    weapons = Equipment.where(equipment_type: 'Weapon')
    render json: EquipmentSerializer.new(weapons).serializable_hash.to_json
  end

  def create
    equipment = Equipment.new(equipment_params)

    if equipment.save
      render json: EquipmentSerializer.new(equipment).serializable_hash.to_json, status: :created
    else
      render json: { error: "Can't create the equipment", messages: equipment.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  def update
    if @equipment.update(equipment_params)
      render json: EquipmentSerializer.new(@equipment).serializable_hash.to_json
    else
      render json: { error: "Can't update the equipment", messages: @equipment.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  def destroy
    @equipment.destroy!
    head :no_content
  end

  private

  def set_equipment
    @equipment = Equipment.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Equipment not found' }, status: :not_found
  end

  def equipment_params
    params.require(:data).require(:attributes).permit(:name, :equipment_type)
  end
end
