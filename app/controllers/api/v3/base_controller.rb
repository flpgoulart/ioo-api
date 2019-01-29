class Api::V3::BaseController < ApplicationController
    include DeviseTokenAuth::Concerns::SetUserByToken
    include ActionController::Cookies
    include ActionController::RequestForgeryProtection
    
    load_and_authorize_resource
end