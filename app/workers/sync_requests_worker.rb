class SyncRequestsWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def initialize
  end

  def perform
    redis_responses = RedisResponse.new
    new_responses = redis_responses.all
    new_responses.each do |response|
        :id, :production_response, :shadow_response, :time, :url
        Response.create(request_id: response.id,, production: response.production_response,
                        shadow: response.shadow_response, url: response.url,
                        time: response.time, Commit.find_or_create_by(hash: response.commit_hash))
    end    
  end

end
