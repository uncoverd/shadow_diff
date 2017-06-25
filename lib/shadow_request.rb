class ShadowRequest
    def initialize
    end

    def all
        REDIS.with do |connection|
            connection.keys("request-*")
        end        
    end    

end    