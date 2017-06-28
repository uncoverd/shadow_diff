class SyncRequestsWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def initialize
  end

  def perform
    redis_responses = RedisResponse.new
    new_responses = redis_responses.all
    new_responses.each do |response|
        commit = Commit.find_or_create_by(commit_hash: response.commit_hash)
        Response.create(request_id: response.id, production: response.production_response,
                        shadow: response.shadow_response, url: response.url,
                        time: response.time, commit: commit)
        redis_responses.delete(response.id)
    end
  end

end
