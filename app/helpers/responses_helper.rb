module ResponsesHelper

    EPSILONS = {:sql => 1, :db_runtime => 70, :view_runtime => 50}

    #use to_f method to cast nil to 0
    def sql_requests_diff
        (production_sql_requests.to_f - shadow_sql_requests.to_f).round(0)
    end
    
    def view_runtime_diff
        production_view_runtime.to_f - shadow_view_runtime.to_f
    end

    def db_runtime_diff
        production_db_runtime.to_f - shadow_db_runtime.to_f
    end

    def view_runtime_diff_output
        view_runtime_diff >= 0 ? "+ #{view_runtime_diff}" : view_runtime_diff
    end
    
    def db_runtime_diff_output
        db_runtime_diff >= 0 ? "+ #{db_runtime_diff}" : db_runtime_diff
    end

    def sql_requests_diff_output
        sql_requests_diff >= 0 ? "+ #{sql_requests_diff}" : sql_requests_diff
    end
    
end
