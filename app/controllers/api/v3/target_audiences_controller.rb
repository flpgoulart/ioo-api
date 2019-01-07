class Api::V3::TargetAudiencesController < Api::V3::BaseController

    before_action :authenticate_user!
    
    def index
        target_audiences = TargetAudience.ransack(params[:q]).result
        
        render json: target_audiences, status: 200
    end

    def show
        target_audience = TargetAudience.find(params[:id])
        render json: target_audience, status: 200
    end

    def create
        target_audience = TargetAudience.new(target_audience_params)
        if target_audience.save
            render json: target_audience, status: 201
        else
            render json: { errors: target_audience.errors }, status: 422
        end 
    end

    def update
        target_audience = TargetAudience.find(params[:id])

        if target_audience.update_attributes(target_audience_params)
            render json: target_audience, status: 200
        else
            render json: { errors: target_audience.errors }, status: 422
        end
    end

    def destroy
        target_audience = TargetAudience.find(params[:id])
        target_audience.destroy
        head 204
    end

    private
    def target_audience_params
        params.require(:target_audience).permit(:name)
    end
end
