class RawResponse
    attr_accessor :id, :production_response, :shadow_response, :time, :url, :commit_hash

    def initialize(id)
        @id = id
    end
end    