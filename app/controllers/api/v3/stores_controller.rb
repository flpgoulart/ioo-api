class Api::V3::StoresController < Api::V3::BaseController

    before_action :authenticate_user!
    
    def index
        stores = current_user.stores.ransack(params[:q]).result
        render json: stores, status: 200
    end
    
    def show
        store = current_user.stores.find(params[:id])
        render json: store, status: 200
    end

    def create
        store = current_user.stores.build(store_params)
        
        if store.save
            render json: store, status: 201
        else
            render json: { errors: store.errors }, status: 422
        end 
    end

    def update
        store = current_user.stores.find(params[:id])

        if store.update_attributes(store_params)
            render json: store, status: 200
        else
            render json: { errors: store.errors }, status: 422
        end
    end

    # def destroy
    #     store = current_user.stores.find(params[:id])
    #     store.destroy
    #     head 204
    # end

    private
    def store_params
        params.require(:store).permit(:name, :store_type_id, :business_id, :city_id, :cep, :address_name, :contact_info, :status)
    end

end

