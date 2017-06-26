class ShadowController < ApplicationController

    def index
        redis_requests = RedisResponse.new
        @requests = redis_requests.all
    end

    def show
        redis_requests = RedisResponse.new
        @request = redis_requests.find(params[:id])
    end      
end
