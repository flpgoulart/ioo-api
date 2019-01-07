class Api::V3::VolunteerListsController < Api::V3::BaseController

    before_action :authenticate_user!
    
    def index
        volunteer_lists = VolunteerList.ransack(params[:q]).result
        render json: volunteer_lists, status: 200
    end

    def show
        volunteer_list = VolunteerList.find(params[:id])
        render json: volunteer_list, status: 200
    end

    def create
        volunteer_list = VolunteerList.create(volunteer_list_params)
        
        if volunteer_list.save
            render json: volunteer_list, status: 201
        else
            render json: { errors: volunteer_list.errors }, status: 422
        end 
    end

    def update
        volunteer_list = VolunteerList.find(params[:id])

        if volunteer_list.update_attributes(volunteer_list_params)
            render json: volunteer_list, status: 200
        else
            render json: { errors: volunteer_list.errors }, status: 422
        end
    end

    def destroy
        volunteer_list = VolunteerList.find(params[:id])
        volunteer_list.destroy
        head 204
    end

    private
    def volunteer_list_params
        params.require(:volunteer_list).permit(:volunteer_id, :improvement_id, :attendance, :rate_volunteer, 
                                               :rate_improvement, :rate_social_entity)

    end


end
