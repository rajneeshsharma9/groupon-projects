module Api
  class BaseController < ApplicationController

    before_action :authenticate_request
    skip_before_action :authorize

    # to check if request has API token
    private def authenticate_request
      api_token = request.headers['api-token']
      if api_token.nil?
        render json: { errors: "API token missing in request header" }, status: 403
      elsif User.find_by(api_token: api_token).nil?
        render json: { errors: "Wrong API token" }, status: 403
      end
    end

  end
end
