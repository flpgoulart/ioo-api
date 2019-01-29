class Api::V3::SearchController < ApplicationController

    def offers

        if search_params[:city_id].present?
            session[:last_city_id] = params[:city_id]
        end 

        if session[:last_city_id]
            #começa a condição considerando a cidade referente
            conditions = ["SELECT offers.* FROM offers 
                            INNER JOIN campaigns ON campaigns.id = offers.campaign_id 
                            INNER JOIN store_campaigns ON store_campaigns.campaign_id = campaigns.id 
                            INNER JOIN stores ON stores.id = store_campaigns.store_id
                            INNER JOIN products ON products.id = offers.product_id
                            INNER JOIN subcategories ON subcategories.id = products.subcategory_id
                            WHERE offers.status = 'A'
                            AND   campaigns.status = 'A'
                            AND   store_campaigns.status = 'A'
                            AND   stores.status = 'A'
                            AND   stores.city_id = ?"]

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

            if search_params[:product_id].present? 
                conditions << "products.id = ?"
                cond_data  << search_params[:product_id]
            end 

            if search_params[:business_id].present? 
                conditions << "stores.business_id = ?"
                cond_data  << search_params[:business_id]
            end 

            if search_params[:store_id].present? 
                conditions << "stores.id = ?"
                cond_data  << search_params[:store_id]
            end 

            if search_params[:category_id].present? 
                conditions << "subcategories.category_id = ?"
                cond_data  << search_params[:category_id]
            end 

            if search_params[:subcategory_id].present? 
                conditions << "subcategories.id = ?"
                cond_data  << search_params[:subcategory_id]
            end 

            if search_params[:brand_name].present?
                conditions << "UPPER(offers.brand_name) LIKE UPPER(?)"
                cond_data  << "%#{search_params[:brand_name]}%"
            end 

            ordering = ""
            if search_params[:order].present?
                ordering = "ORDER BY " + search_params[:order]
            end 

            offers = Offer.find_by_sql([conditions.join(" AND ") + ordering, *cond_data])

            if offers.empty?
                render json: msg_return = {
                    code: "999",
                    message: "no-data-found",
                    description: "no-data-found"
                }, status: 404
            else
                render json: offers, status: 200
            end

        else 
            render json: msg_return = {
                code: "909",
                message: "no-city-selected",
                description: "no-city-selected"
            }, status: 404
        end 

    end 


    private
    def search_params
        params.permit(:city_id, :name_offer, :business_id, :store_id, :category_id, :subcategory_id, :brand_name, :product_id, :order )
    end


end

