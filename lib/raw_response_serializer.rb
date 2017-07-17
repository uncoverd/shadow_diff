class RawResponseSerializer
    def initialize(connection)
        @connection = connection
    end

    def find (key)
        raw_response = RawResponse.new(key).tap do |response|
            response.production_response = @connection.hget(key, "production")
            response.shadow_response = @connection.hget(key, "shadow")
            response.production_request = @connection.hget(key, "production_request")
            response.shadow_request = @connection.hget(key, "shadow_request")

            response.url = @connection.hget(key,"url")

            unless response.url.include?("assets")
                shadow_sql_requests_match = response.shadow_response.scan(/X-Sql-Queries: (\d*)/)
                response.shadow_sql_requests = shadow_sql_requests_match[0][0] if shadow_sql_requests_match.size > 0
                production_sql_requests_match = response.production_response.scan(/X-Sql-Queries: (\d*)/)
                response.production_sql_requests = production_sql_requests_match[0][0] if production_sql_requests_match.size > 0


                shadow_view_runtime_match = response.shadow_response.scan(/X-View-Runtime: (\d*)/)
                response.shadow_view_runtime = shadow_view_runtime_match[0][0] if shadow_view_runtime_match.size > 0
                production_view_runtime_match = response.production_response.scan(/X-View-Runtime: (\d*)/)
                response.production_view_runtime = production_view_runtime_match[0][0] if production_view_runtime_match.size > 0

                shadow_db_runtime_match = response.shadow_response.scan(/X-Db-Runtime: (\d*)/)
                response.shadow_db_runtime = shadow_db_runtime_match[0][0] if shadow_db_runtime_match.size > 0
                production_db_runtime_match = response.production_response.scan(/X-Db-Runtime: (\d*)/)
                response.production_db_runtime = production_db_runtime_match[0][0] if production_db_runtime_match.size > 0
            end    

            response.time = @connection.hget(key, "time")
            response.commit_hash = @connection.hget(key, "commit_hash")
            response.verb = @connection.hget(key,"verb")
        end
    end    

end