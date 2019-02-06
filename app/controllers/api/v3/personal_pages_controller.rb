class Api::V3::PersonalPagesController < Api::V3::BaseController

    before_action :authenticate_user!
    
    def index
        personal_pages = current_user.personal_pages.ransack(params[:q]).result
        render json: personal_pages, status: 200
    end
    
    def create
        personal_page = current_user.personal_pages.build(personal_page_params)
        
        if personal_page.save
            render json: personal_page, status: 201
        else
            render json: { errors: personal_page.errors }, status: 422
        end 
    end

    def destroy
        personal_page = current_user.personal_pages.find(params[:id])
        personal_page.destroy
        head 204
    end

    private
    def personal_page_params
        params.require(:personal_page).permit(:category_id)
    end
    
end
