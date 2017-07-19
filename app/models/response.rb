class Response < ApplicationRecord
    belongs_to :commit
    belongs_to :url
    has_many :rules, dependent: :destroy
    has_many :comparison_results, dependent: :destroy
    include ResponsesHelper

    MAX_RUNTIME = 200
    MAX_QUERIES = 20
    NEGATIVE_METRIC_SCORE = -20

    def color
        score >= 0 ? "green" : "red"
    end

    def metric_score
        if view_runtime_diff > MAX_RUNTIME || db_runtime_diff > MAX_RUNTIME || sql_requests_diff > MAX_QUERIES
            NEGATIVE_METRIC_SCORE
        else
            0
        end        
    end    
end
