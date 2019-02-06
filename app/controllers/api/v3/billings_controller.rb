class Api::V3::BillingsController < Api::V3::BaseController
    before_action :authenticate_user!
    
    def index
        billings = current_user.billings.ransack(params[:q]).result
        render json: billings, status: 200
    end
    
    def show
        billing = current_user.billings.find(params[:id])
        render json: billing, status: 200
    end

    def create
        billing = current_user.billings.build(billing_params)
        
        if billing.save
            render json: billing, status: 201
        else
            render json: { errors: billing.errors }, status: 422
        end 
    end

    def update
        billing = current_user.billings.find(params[:id])

        if billing.update_attributes(billing_params)
            render json: billing, status: 200
        else
            render json: { errors: billing.errors }, status: 422
        end
    end

    def destroy
        billing = current_user.billings.find(params[:id])
        billing.destroy
        head 204
    end

    private
    def billing_params
        params.require(:billing).permit(:document, :doc_date, :ref_ini_date, :ref_end_date, :link_document, :status)
    end


end
