class ShadowController < ApplicationController
    def index
        redis_responses = RedisResponse.new
        @pending_requests = redis_responses.all
        @commits = Commit.all
        @processed_requests = Response.all.group_by(&:commit)
        @urls = Response.all.pluck(:url)
    end

    def show
        @response = Response.find(params[:id])
    end      
end
