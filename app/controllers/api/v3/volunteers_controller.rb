class Api::V3::VolunteersController < Api::V3::BaseController
    before_action :authenticate_user!
    
    def index
        volunteers = current_user.volunteers.ransack(params[:q]).result
        render json: volunteers, status: 200
    end

    def show
        volunteer = current_user.volunteers.find(params[:id])
        render json: volunteer, status: 200
    end

    def create
        volunteer = current_user.volunteers.build(volunteer_params)
        
        if volunteer.save
            render json: volunteer, status: 201
        else
            render json: { errors: volunteer.errors }, status: 422
        end 
    end

    def update
        volunteer = current_user.volunteers.find(params[:id])

        if volunteer.update_attributes(volunteer_params)
            render json: volunteer, status: 200
        else
            render json: { errors: volunteer.errors }, status: 422
        end
    end

    def destroy
        volunteer = current_user.volunteers.find(params[:id])
        volunteer.destroy
        head 204
    end

    private
    def volunteer_params
        params.require(:volunteer).permit(:name, :address, :address_comp, :status)

    end


end
