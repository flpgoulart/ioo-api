class Api::V3::ShoppingListsController < Api::V3::BaseController

    before_action :authenticate_user!
    
    def index
        shopping_lists = current_user.shopping_lists.ransack(params[:q]).result
        render json: shopping_lists, status: 200
    end
    
    def show
        shopping_list = current_user.shopping_lists.find(params[:id])
        render json: shopping_list, status: 200
    end

    def create
        shopping_list = current_user.shopping_lists.build(shopping_list_params)
        
        if shopping_list.save
            render json: shopping_list, status: 201
        else
            render json: { errors: shopping_list.errors }, status: 422
        end 
    end

    def update
        shopping_list = current_user.shopping_lists.find(params[:id])

        if shopping_list.update_attributes(shopping_list_params)
            render json: shopping_list, status: 200
        else
            render json: { errors: shopping_list.errors }, status: 422
        end
    end

    # def destroy
    #     shopping_list = current_user.shopping_lists.find(params[:id])
    #     shopping_list.destroy
    #     head 204
    # end

    private
    def shopping_list_params
        params.require(:shopping_list).permit(:name)
    end

end
