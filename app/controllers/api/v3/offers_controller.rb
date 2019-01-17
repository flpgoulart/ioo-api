class Api::V3::OffersController < Api::V3::BaseController

    before_action :authenticate_user!
    
    def index
        offers = current_user.offers.ransack(params[:q]).result
        render json: offers, status: 200
    end
    
    def show
        offer = current_user.offers.find(params[:id])
        render json: offer, status: 200
    end

    def create
        offer = current_user.offers.build(offer_params)
        
        if offer.save
            render json: offer, status: 201
        else
            render json: { errors: offer.errors }, status: 422
        end 
    end

    def update
        offer = current_user.offers.find(params[:id])

        if offer.update_attributes(offer_params)
            render json: offer, status: 200
        else
            render json: { errors: offer.errors }, status: 422
        end
    end

    # def destroy
    #     offer = current_user.offers.find(params[:id])
    #     offer.destroy
    #     head 204
    # end

    private
    def offer_params
        params.require(:offer).permit(:name, :brand_name, :product_id, :campaign_id, :disclaimer, :status, :unit_measure_id, :product_value, :offer_value)
    end
    
end
