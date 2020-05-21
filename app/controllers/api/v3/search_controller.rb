class Api::V3::SearchController < ApplicationController

	def clear_session
		reset_session
	end 

    def offers

        if search_params[:city_id].present?
            session[:last_city_id] = search_params[:city_id]
        end 

        if session[:last_city_id]
            #começa a condição considerando a cidade referente
            conditions = ["SELECT offers.* FROM offers " +
                            "INNER JOIN campaigns ON campaigns.id = offers.campaign_id " +
                            "INNER JOIN store_campaigns ON store_campaigns.campaign_id = campaigns.id " +
                            "INNER JOIN stores ON stores.id = store_campaigns.store_id " +
                            "INNER JOIN products ON products.id = offers.product_id " +
                            "INNER JOIN subcategories ON subcategories.id = products.subcategory_id " +
                            "WHERE offers.status = 'A' " +
                            "AND   campaigns.status = 'A' " +
                            "AND   store_campaigns.status = 'A' " +
                            "AND   stores.status = 'A' " +
                            "AND   stores.city_id = ?"]

            cond_data = [session[:last_city_id]]

            #adiciona o periodo de vigencia da campanha
            # data inicio
            conditions << "campaigns.start_date <= ?"
            cond_data  << Date.today

            # data fim
            conditions << "campaigns.end_date >= ?"
            cond_data  << Date.today

            # se o parametro do nome estiver preenchido 
            if search_params[:name_offer].present?
                conditions << "UPPER(offers.name) LIKE UPPER(?)"
                cond_data  << "%#{search_params[:name_offer]}%"
            end 

            #se o parametro produto estiver presente
            if search_params[:product_id].present? 
                conditions << "products.id = ?"
                cond_data  << search_params[:product_id]
            end 

            # se o parametro de empresa estiver preenchido
            if search_params[:business_id].present? 
                conditions << "stores.business_id = ?"
                cond_data  << search_params[:business_id]
            end 

            # se o parametro loja estiver preenchido
            if search_params[:store_id].present? 
                conditions << "stores.id = ?"
                cond_data  << search_params[:store_id]
            end 

            # se o parametro categoria estiver preenchido
            if search_params[:category_id].present? 
                conditions << "subcategories.category_id = ?"
                cond_data  << search_params[:category_id]
            end 

            # se o parametro subcategoria estiver preenchido
            if search_params[:subcategory_id].present? 
                conditions << "subcategories.id = ?"
                cond_data  << search_params[:subcategory_id]
            end 

            # se o parametro marca estiver preenchido
            if search_params[:brand_name].present?
                conditions << "UPPER(offers.brand_name) LIKE UPPER(?)"
                cond_data  << "%#{search_params[:brand_name]}%"
            end 

            # inicializa a variavel de ordenação para evitar erros
            ordering = ""
            # atribui conforme parametro enviado, permitindo flexibilidade 
            if search_params[:order].present?
                ordering = "ORDER BY " + search_params[:order]
            end 

            poffers = Offer.find_by_sql([conditions.join(" AND ") + ordering, *cond_data])

            if poffers.empty?
                render json: msg_return = {
                    code: "999",
                    message: "no-data-found",
                    description: "no-data-found"
                }, status: 404
            else
                render json: poffers, status: 200
            end

        else 
            render json: msg_return = {
                code: "909",
                message: "no-city-selected",
                description: "no-city-selected"
            }, status: 404
        end 

    end 


    def cities 
        pcities = City.find_by_sql(["SELECT * FROM cities WHERE UPPER(cities.name) LIKE UPPER(?)", "%#{search_params[:name_city]}%"])
        render json: pcities, status: 200
    end 


    def businesses 
        if session[:last_city_id]        
            pbusinesses = Business.find_by_sql(["SELECT businesses.* FROM businesses " +
                                                "INNER JOIN stores ON stores.business_id = businesses.id " +
                                                "WHERE stores.status = 'A' " +
                                                "AND   stores.city_id = ?",session[:last_city_id]])

            if pbusinesses.empty?
                render json: msg_return = {
                    code: "999",
                    message: "no-data-found",
                    description: "no-data-found"
                }, status: 404
            else 
                render json: pbusinesses, status: 200
            end 
        else
            render json: msg_return = {
                code: "909",
                message: "no-city-selected",
                description: "no-city-selected"
            }, status: 404
        end 
    end 


    def stores
        if session[:last_city_id]        
            pstores = Store.find_by_sql(["SELECT stores.* FROM stores " +
                                         "WHERE stores.status = 'A' " +
                                         "AND   stores.city_id = ?",session[:last_city_id]])

            if pstores.empty?
                render json: msg_return = {
                    code: "999",
                    message: "no-data-found",
                    description: "no-data-found"
                }, status: 404
            else 
                render json: pstores, status: 200
            end 
        else
            render json: msg_return = {
                code: "909",
                message: "no-city-selected",
                description: "no-city-selected"
            }, status: 404
        end 
    end 


    def categories
        pcategories = Category.all 

        if pcategories.empty?
            render json: msg_return = {
                code: "999",
                message: "no-data-found",
                description: "no-data-found"
            }, status: 404

        else 
            render json: pcategories, status: 200
        end 
    end 


    def subcategories 

        if search_params[:category_id].present? 

            psubcategories = Subcategory.where(:category_id => search_params[:category_id]) 

            if psubcategories.empty?
                render json: msg_return = {
                    code: "999",
                    message: "no-data-found",
                    description: "no-data-found"
                }, status: 404

            else 
                render json: psubcategories, status: 200
            end 

        else 
            render json: msg_return = {
                code: "908",
                message: "pcategory-empty",
                description: "pcategory-empty"
            }, status: 404
        end 
    end 


    private
    def search_params
        params.permit(:city_id, :name_offer, :business_id, :store_id, :category_id, :subcategory_id, :brand_name, :product_id, :order, :name_city )
    end


end

