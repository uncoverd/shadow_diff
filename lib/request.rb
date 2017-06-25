class Request
    attr_accessor :id, :production_response, :shadow_response, :time

    def initialize(id)
        @id = id
    end
end    