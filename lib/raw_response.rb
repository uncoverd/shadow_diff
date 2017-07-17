class RawResponse
    attr_accessor :id, :production_response, :shadow_response, :production_request, :shadow_request, :verb,
                :time, :url, :commit_hash, :shadow_sql_requests, :production_sql_requests, :shadow_view_runtime,
                 :production_view_runtime, :shadow_db_runtime, :production_db_runtime
    def initialize(id)
        @id = id
    end
end    