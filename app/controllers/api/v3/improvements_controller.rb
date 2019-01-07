class Api::V3::ImprovementsController < Api::V3::BaseController
    before_action :authenticate_user!
    
    def index
        social_entity = current_user.social_entities.first 
        improvements = social_entity.improvements.ransack(params[:q]).result
        render json: improvements, status: 200
    end

    def show
        social_entity = current_user.social_entities.first 
        improvement = social_entity.improvements.find(params[:id])
        render json: improvement, status: 200
    end

    def create
        social_entity = current_user.social_entities.first
        
        improvement = social_entity.improvements.build(improvement_params)
        
        if improvement.save
            render json: improvement, status: 201
        else
            render json: { errors: improvement.errors }, status: 422
        end 
    end

    def update
        social_entity = current_user.social_entities.first

        improvement = social_entity.improvements.find(params[:id])

        if improvement.update_attributes(improvement_params)
            render json: improvement, status: 200
        else
            render json: { errors: improvement.errors }, status: 422
        end
    end

    def destroy
        social_entity = current_user.social_entities.first
        
        improvement = social_entity.improvements.find(params[:id])
        improvement.destroy
        head 204
        
    end

    private
    def improvement_params
        params.require(:improvement).permit(:title, :short_description, :description, :people_benefited,
                                            :address, :address_comp, :limit_volunteers, 
                                            :start_date, :end_date, :knowledge_required, 
                                            :support_materials, :status, :social_entity_id)

    end

end

