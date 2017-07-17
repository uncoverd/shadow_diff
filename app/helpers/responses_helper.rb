module ResponsesHelper

    EPSILONS = {:sql => 1, :db_runtime => 70, :view_runtime => 50}

    def sql_requests_diff
        (production_sql_requests - shadow_sql_requests).round(0)
    end
    
    def view_runtime_diff
        production_view_runtime - shadow_view_runtime
    end

    def db_runtime_diff
        production_db_runtime - shadow_db_runtime
    end

    def view_runtime_diff_output
        view_runtime_diff >= 0 ? "+ #{view_runtime_diff}" : "-#{view_runtime_diff}"
    end
    
    def db_runtime_diff_output
        db_runtime_diff >= 0 ? "+ #{db_runtime_diff}" : "-#{db_runtime_diff}"
    end

    def sql_requests_diff_output
        sql_requests_diff >= 0 ? "+ #{sql_requests_diff}" : "-#{sql_requests_diff}"
    end
    
end
