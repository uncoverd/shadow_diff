class SyncRequestsWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def initialize
  end

  def perform
    redis_connection = RedisConnection.new
    new_responses = redis_connection.all
    new_responses.each do |response|
        if response.url.include?("assets")
            
        else
          commit = Commit.find_or_create_by(commit_hash: response.commit_hash)
          commit.score = 0
          commit.save
          url = Url.find_or_create_by(path: response.url)
          db_response = Response.create(request_id: response.id, production: response.production_response,
                          shadow: response.shadow_response, url: url, time: response.time,
                          commit: commit, production_request: response.production_request,
                          shadow_request: response.shadow_request, verb: response.verb, shadow_sql_requests: response.shadow_sql_requests,
                          production_sql_requests: response.production_sql_requests, shadow_view_runtime: response.shadow_view_runtime, 
                          production_view_runtime: response.production_view_runtime, shadow_db_runtime: response.shadow_db_runtime,
                          production_db_runtime: response.production_db_runtime)                          
          Rule.default_regexes.each do |regex, name|
            Rule.find_or_create_by(modifier: 0, name: name, regex_string: regex, url: url,
                                  commit: commit, status: :active, action: :modify, response: db_response)
          end
        end    
        redis_connection.delete(response.id)
    end
    if new_responses.any?
      ScoreUpdateWorker.perform_async
    end  
  end

end
