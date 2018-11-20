module Admin
  class LocationsController < BaseController

    before_action :find_location_by_id, only: %i[show edit update destroy]

    def index
      @locations = Location.order(created_at: :desc)
    end

    def show; end

    def new
      @location = Location.new
      @location.build_address
    end

    def edit; end

    def create
      @location = Location.new(permitted_location_params)
      if @location.save
        redirect_to admin_location_path(@location), info: t('.location_created')
      else
        render :new
      end
    end

    def update
      if @location.update(permitted_location_params)
        redirect_to admin_location_path(@location), success: t('.location_updated')
      else
        render :edit
      end
    end

    def destroy
      if @location.destroy
        redirect_to admin_locations_path, info: t('.location_deleted')
      else
        redirect_to admin_locations_path, info: t('.error_has_occured')
      end
    end

    private def find_location_by_id
      @location = Location.find_by(id: params[:id])
      if @location.nil?
        redirect_to admin_locations_path, danger: t('.location_not_found')
      end
    end

    private def permitted_location_params
      params.require(:location).permit(:name,  address_attributes: [:id, :street_address, :state, :city, :country, :pincode, :contact_person_name, :contact_number])
    end

  end
end
