class Api::V3::BaseController < ApplicationController
    include DeviseTokenAuth::Concerns::SetUserByToken
    load_and_authorize_resource
end