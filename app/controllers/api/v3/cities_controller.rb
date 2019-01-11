class Api::V3::CitiesController < Api::V3::BaseController

    before_action :authenticate_user!
    
    def index
        cities = City.ransack(params[:q]).result
        render json: cities, status: 200
    end
    
    def show
        city = City.find(params[:id])
        render json: city, status: 200
    end

    def create
        city = City.create(city_params)
        
        if city.save
            render json: city, status: 201
        else
            render json: { errors: city.errors }, status: 422
        end 
    end

    def update
        city = City.find(params[:id])

        if city.update_attributes(city_params)
            render json: city, status: 200
        else
            render json: { errors: city.errors }, status: 422
        end
    end

    def destroy
        city = City.find(params[:id])
        city.destroy
        head 204
    end

    private
    def city_params
        params.require(:city).permit(:name, :cep_begin, :cep_end, :uf)
    end

end
