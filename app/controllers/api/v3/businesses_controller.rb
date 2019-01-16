class Api::V3::BusinessesController < Api::V3::BaseController

    before_action :authenticate_user!
    
    def index
        businesses = current_user.businesses.ransack(params[:q]).result
        render json: businesses, status: 200
    end
    
    def show
        business = current_user.businesses.find(params[:id])
        render json: business, status: 200
    end

    def create
        business = current_user.businesses.build(business_params)
        
        if business.save
            render json: business, status: 201
        else
            render json: { errors: business.errors }, status: 422
        end 
    end

    def update
        business = current_user.businesses.find(params[:id])

        if business.update_attributes(business_params)
            render json: business, status: 200
        else
            render json: { errors: business.errors }, status: 422
        end
    end

    # def destroy
    #     business = current_user.businesses.find(params[:id])
    #     business.destroy
    #     head 204
    # end

    private
    def business_params
        params.require(:business).permit(:name, :about_us, :url_site, :url_facebook, :contact_info)
    end


end
