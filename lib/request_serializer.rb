class RequestSerializer
    def initialize(connection)
        @connection = connection
    end

    def find (key)
        request = Request.new(key)
        request.production_response = @connection.hget(key, "production")
        request.shadow_response = @connection.hget(key, "shadow")
        request.time = @connection.hget(key, "time")
        request.url = request.production_response[/X-XHR-Current-Location(.*)$/].split(':')[1]
        request 
    end    

end    