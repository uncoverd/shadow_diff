class RawResponse
    attr_accessor :id, :production_response, :shadow_response, :time, :url

    def initialize(id)
        @id = id
    end
end    