class Api::V3::UnitMeasuresController < Api::V3::BaseController

    before_action :authenticate_user!
    
    def index
        unit_measures = UnitMeasure.ransack(params[:q]).result
        render json: unit_measures, status: 200
    end
    
    def show
        unit_measure = UnitMeasure.find(params[:id])
        render json: unit_measure, status: 200
    end

    def create
        unit_measure = UnitMeasure.create(unit_measure_params)
        
        if unit_measure.save
            render json: unit_measure, status: 201
        else
            render json: { errors: unit_measure.errors }, status: 422
        end 
    end

    def update
        unit_measure = UnitMeasure.find(params[:id])

        if unit_measure.update_attributes(unit_measure_params)
            render json: unit_measure, status: 200
        else
            render json: { errors: unit_measure.errors }, status: 422
        end
    end

    def destroy
        unit_measure = UnitMeasure.find(params[:id])
        unit_measure.destroy
        head 204
    end

    private
    def unit_measure_params
        params.require(:unit_measure).permit(:name)
    end

end
