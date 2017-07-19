module ResponsesHelper

    EPSILONS = {:sql => 1, :db_runtime => 70, :view_runtime => 50}

    #use to_f method to cast nil to 0
    def sql_requests_diff
        (shadow_sql_requests.to_f - production_sql_requests.to_f).round(0)
    end
    
    def view_runtime_diff
        shadow_view_runtime.to_f - production_view_runtime.to_f
    end

    def db_runtime_diff
        shadow_db_runtime.to_f - production_db_runtime.to_f
    end

    def view_runtime_diff_output
        view_runtime_diff >= 0 ? "+ #{view_runtime_diff}" : view_runtime_diff
    end
    
    def db_runtime_diff_output
        db_runtime_diff >= 0 ? "+ #{db_runtime_diff}" : db_runtime_diff
    end

    def sql_requests_diff_output
        if sql_requests_diff == 0
            'No change'
        elsif sql_requests_diff > 0
            "+ #{sql_requests_diff}"
        else
            sql_requests_diff
        end          
    end

    def metric_score_color
        metric_score == 0 ? 'success' : 'danger'
    end
    
    def shadow_diff_color
        score == 0 ? 'success' : 'danger'
    end    
    
end
