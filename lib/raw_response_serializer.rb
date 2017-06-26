class RawResponseSerializer
    def initialize(connection)
        @connection = connection
    end

    def find (key)
        response = RawResponse.new(key)
        response.production_response = @connection.hget(key, "production")
        response.shadow_response = @connection.hget(key, "shadow")
        response.time = @connection.hget(key, "time")
        response.url = response.production_response[/X-XHR-Current-Location(.*)$/].split(':')[1]
        response 
    end    

end    