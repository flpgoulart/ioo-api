class Api::V3::BusinessAccountsController < Api::V3::BaseController

    before_action :authenticate_user!
    
    def index
        business_accounts = current_user.business_accounts.ransack(params[:q]).result
        render json: business_accounts, status: 200
    end
    
    def show
        business_account = current_user.business_accounts.find(params[:id])
        render json: business_account, status: 200
    end

    def create
        business_account = current_user.business_accounts.build(business_account_params)
        
        if business_account.save
            render json: business_account, status: 201
        else
            render json: { errors: business_account.errors }, status: 422
        end 
    end

    def update
        business_account = current_user.business_accounts.find(params[:id])

        if business_account.update_attributes(business_account_params)
            render json: business_account, status: 200
        else
            render json: { errors: business_account.errors }, status: 422
        end
    end

    # def destroy
    #     business = current_user.businesses.find(params[:id])
    #     business.destroy
    #     head 204
    # end

    private
    def business_account_params
        params.require(:business_account).permit(:name, :cnpj, :insce, :inscm, :city_name, :uf, :email, :ddd_phone, :phone, :ddd_mobile, :mobile, :address_name, :cep, :plan, :status )
    end

end
