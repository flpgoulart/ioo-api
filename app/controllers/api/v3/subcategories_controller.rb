class Api::V3::SubcategoriesController < Api::V3::BaseController

    before_action :authenticate_user!
    
    def index
        subcategories = Subcategory.ransack(params[:q]).result
        render json: subcategories, status: 200
    end
    
    def show
        subcategory = Subcategory.find(params[:id])
        render json: subcategory, status: 200
    end

    def create
        subcategory = Subcategory.create(subcategory_params)
        
        if subcategory.save
            render json: subcategory, status: 201
        else
            render json: { errors: subcategory.errors }, status: 422
        end 
    end

    def update
        subcategory = Subcategory.find(params[:id])

        if subcategory.update_attributes(subcategory_params)
            render json: subcategory, status: 200
        else
            render json: { errors: subcategory.errors }, status: 422
        end
    end

    def destroy
        subcategory = Subcategory.find(params[:id])
        subcategory.destroy
        head 204
    end

    private
    def subcategory_params
        params.require(:subcategory).permit(:name, :description, :category_id, :market_session, :logo)
    end


end
