class Api::V3::CampaignsController < Api::V3::BaseController

    before_action :authenticate_user!
    
    def index
        campaigns = current_user.campaigns.ransack(params[:q]).result
        render json: campaigns, status: 200
    end
    
    def show
        campaign = current_user.campaigns.find(params[:id])
        render json: campaign, status: 200
    end

    def create
        campaign = current_user.campaigns.build(campaign_params)
        
        if campaign.save
            render json: campaign, status: 201
        else
            render json: { errors: campaign.errors }, status: 422
        end 
    end

    def update
        campaign = current_user.campaigns.find(params[:id])

        if campaign.update_attributes(campaign_params)
            render json: campaign, status: 200
        else
            render json: { errors: campaign.errors }, status: 422
        end
    end

    # def destroy
    #     campaign = current_user.campaigns.find(params[:id])
    #     campaign.destroy
    #     head 204
    # end

    private
    def campaign_params
        params.require(:campaign).permit(:name, :disclaimer, :start_date, :end_date, :status)
    end


end
