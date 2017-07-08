class SyncRequestsWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def initialize
  end

  def perform
    redis_connection = RedisConnection.new
    new_responses = redis_connection.all
    new_responses.each do |response|
        commit = Commit.find_or_create_by(commit_hash: response.commit_hash)
        url = Url.find_or_create_by(path: response.url)
        db_response = Response.create(request_id: response.id, production: response.production_response,
                        shadow: response.shadow_response, url: url, time: response.time,
                        commit: commit, request: response.request, verb: response.verb)
        Rule.default_regexes.each do |regex, name|
          Rule.find_or_create_by(modifier: 0, name: name, regex_string: regex, url: url,
                                 commit: commit, status: :active, action: :modify, response: db_response)
        end  
        redis_connection.delete(response.id)
    end
    Commit.last.update_scores
  end

end
