class Api::V3::ShoppingListOffersController < Api::V3::BaseController

    before_action :authenticate_user!
    
    def index
        shopping_list_offers = current_user.shopping_list_offers.ransack(params[:q]).result
        render json: shopping_list_offers, status: 200
    end
    
    def show
        shopping_list_offer = current_user.shopping_list_offers.find(params[:id])
        render json: shopping_list_offer, status: 200
    end

    def create
        shopping_list_offer = current_user.shopping_list_offers.build(shopping_list_offer_params)
        
        if shopping_list_offer.save
            render json: shopping_list_offer, status: 201
        else
            render json: { errors: shopping_list_offer.errors }, status: 422
        end 
    end

    def update
        shopping_list_offer = current_user.shopping_list_offers.find(params[:id])

        if shopping_list_offer.update_attributes(shopping_list_offer_params)
            render json: shopping_list_offer, status: 200
        else
            render json: { errors: shopping_list_offer.errors }, status: 422
        end
    end

    # def destroy
    #     shopping_list_offer = current_user.shopping_list_offers.find(params[:id])
    #     shopping_list_offer.destroy
    #     head 204
    # end

    private
    def shopping_list_offer_params
        params.require(:shopping_list_offer).permit(:status, :offer_id, :shopping_list_id)
    end

    
end
