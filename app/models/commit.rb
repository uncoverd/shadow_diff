class Commit < ApplicationRecord
    include CommitsHelper
    has_many :responses, dependent: :destroy
    MIN_NUMBER_RESPONSES = 10

    GITHUB_DESCRIPTION = {
        'sucess' => 'passed',
        'pending' => 'in progress',
        'failure' => 'failed',
        'error' => 'error'
    }

    def update_scores
        Rule.where(status: :missing).destroy_all
        responses.each do |response|
            comparator = ResponseComparator.new(response, response.rules.where(status: :active))
            response.score = comparator.calculate_score
            response.save
        end
        self.score = responses.inject(0){|sum,x| sum + x.score }
        self.save
    end

    def negative_responses
        responses.map(&:score).select(&:negative?).count
    end       

    def completion_ratio
        (responses.count.to_f/MIN_NUMBER_RESPONSES) * 100
    end
    
    def github_status
        if completion_ratio >= 100 && score >= 0
            'success'
        elsif completion_ratio < 100
            'pending'
        else    
            'failure'
        end    
    end
    
    def github_description
        GITHUB_DESCRIPTION[github_status]
    end
end
