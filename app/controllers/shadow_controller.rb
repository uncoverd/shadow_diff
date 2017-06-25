class ShadowController < ApplicationController

    def index
        redis_requests = RedisRequest.new
        @requests = redis_requests.all
    end    
end
