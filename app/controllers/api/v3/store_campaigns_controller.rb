class Api::V3::StoreCampaignsController < Api::V3::BaseController
    before_action :authenticate_user!
    
    def index
        store_campaigns = current_user.store_campaigns.ransack(params[:q]).result
        render json: store_campaigns, status: 200
    end
    
    def show
        store_campaign = current_user.store_campaigns.find(params[:id])
        render json: store_campaign, status: 200
    end

    def create
        store_campaign = current_user.store_campaigns.build(store_campaign_params)
        
        if store_campaign.save
            render json: store_campaign, status: 201
        else
            render json: { errors: store_campaign.errors }, status: 422
        end 
    end

    def update
        store_campaign = current_user.store_campaigns.find(params[:id])

        if store_campaign.update_attributes(store_campaign_params)
            render json: store_campaign, status: 200
        else
            render json: { errors: store_campaign.errors }, status: 422
        end
    end

    # def destroy
    #     campaign = current_user.campaigns.find(params[:id])
    #     campaign.destroy
    #     head 204
    # end

    private
    def store_campaign_params
        params.require(:store_campaign).permit(:status, :store_id, :campaign_id)
    end
end
