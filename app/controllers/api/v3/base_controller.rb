class Api::V3::BaseController < ApplicationController
    include DeviseTokenAuth::Concerns::SetUserByToken
end