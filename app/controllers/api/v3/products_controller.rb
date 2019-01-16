class Api::V3::ProductsController < Api::V3::BaseController

    before_action :authenticate_user!
    
    def index
        products = Product.ransack(params[:q]).result
        render json: products, status: 200
    end
    
    def show
        product = Product.find(params[:id])
        render json: product, status: 200
    end

    def create
        product = Product.create(product_params)
        
        if product.save
            render json: product, status: 201
        else
            render json: { errors: product.errors }, status: 422
        end 
    end

    def update
        product = Product.find(params[:id])

        if product.update_attributes(product_params)
            render json: product, status: 200
        else
            render json: { errors: product.errors }, status: 422
        end
    end

    def destroy
        product = Product.find(params[:id])
        product.destroy
        head 204
    end

    private
    def product_params
        params.require(:product).permit(:name, :logo_default, :subcategory_id, :keywords )
    end

end
