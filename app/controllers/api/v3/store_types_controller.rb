class Api::V3::StoreTypesController < Api::V3::BaseController

    before_action :authenticate_user!
    
    def index
        store_types = StoreType.ransack(params[:q]).result
        render json: store_types, status: 200
    end
    
    def show
        store_type = StoreType.find(params[:id])
        render json: store_type, status: 200
    end

    def create
        store_type = StoreType.create(store_type_params)
        
        if store_type.save
            render json: store_type, status: 201
        else
            render json: { errors: store_type.errors }, status: 422
        end 
    end

    def update
        store_type = StoreType.find(params[:id])

        if store_type.update_attributes(store_type_params)
            render json: store_type, status: 200
        else
            render json: { errors: store_type.errors }, status: 422
        end
    end

    def destroy
        store_type = StoreType.find(params[:id])
        store_type.destroy
        head 204
    end

    private
    def store_type_params
        params.require(:store_type).permit(:name)
    end


end
