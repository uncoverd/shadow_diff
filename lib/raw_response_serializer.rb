class RawResponseSerializer
    def initialize(connection)
        @connection = connection
    end

    def find (key)
        response = RawResponse.new(key)
        response.production_response = @connection.hget(key, "production")
        response.shadow_response = @connection.hget(key, "shadow")
        response.request = @connection.hget(key, "request")
        response.time = @connection.hget(key, "time")
        response.commit_hash = @connection.hget(key, "commit_hash")
        response.url = @connection.hget(key,"url")
        response.verb = @connection.hget(key,"verb")
        response 
    end    

end