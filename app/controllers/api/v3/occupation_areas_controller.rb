class Api::V3::OccupationAreasController < Api::V3::BaseController

    before_action :authenticate_user!
    
    def index
        occupation_areas = OccupationArea.ransack(params[:q]).result
        
        render json: occupation_areas, status: 200
    end

    def show
        occupation_area = OccupationArea.find(params[:id])
        render json: occupation_area, status: 200
    end

    def create
        occupation_area = OccupationArea.new(occupation_area_params)
        if occupation_area.save
            render json: occupation_area, status: 201
        else
            render json: { errors: occupation_area.errors }, status: 422
        end 
    end

    def update
        occupation_area = OccupationArea.find(params[:id])

        if occupation_area.update_attributes(occupation_area_params)
            render json: occupation_area, status: 200
        else
            render json: { errors: occupation_area.errors }, status: 422
        end
    end

    def destroy
        occupation_area = OccupationArea.find(params[:id])
        occupation_area.destroy
        head 204
    end

    private
    def occupation_area_params
        params.require(:occupation_area).permit(:name)
    end
end
