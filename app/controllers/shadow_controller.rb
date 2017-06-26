class ShadowController < ApplicationController

    def index
        redis_requests = RedisRequest.new
        @requests = redis_requests.all
    end

    def show
        redis_requests = RedisRequest.new
        @request = redis_requests.find(params[:id])
    end      
end
