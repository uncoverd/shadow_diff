class RedisRequest
    def initialize
    end

    def all
        requests = []
        REDIS.with do |connection|
            keys = []
            keys = connection.keys("request-*")
            serializer = RequestSerializer.new(connection)
            keys.each do |key|
                requests << serializer.find(key)
            end
        end
        requests    
    end

    def find(request_id)
        REDIS.with do |connection|
            serializer = RequestSerializer.new(connection)
            serializer.find(request_id)
        end
    end
end    