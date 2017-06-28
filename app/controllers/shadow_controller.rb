class ShadowController < ApplicationController

    def index
        redis_responses = RedisResponse.new
        @requests = redis_responses.all
    end

    def show
        redis_responses = RedisResponse.new
        @request = redis_responses.find(params[:id])
    end      
end
