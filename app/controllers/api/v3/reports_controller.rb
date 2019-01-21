class Api::V3::ReportsController < Api::V3::BaseController
    
    before_action :authenticate_user!
    load_and_authorize_resource

    def rep_offers
        authorize! :rep, :offers 
    end 
end
