class Commit < ApplicationRecord
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

    def short_hash
        commit_hash[0..7]
    end    

    def completion_color
        completion_ratio >= 100 ? 'sucess' : 'warning'
    end

    def score_icon
        score >= 0 ? 'ok text-success' : 'remove text-danger'
    end

    def completion_ratio
        (responses.count.to_f/MIN_NUMBER_RESPONSES) * 100
    end
    
    def github_status
        if completion_ratio >= 100 && score >= 0
            'success'
        else
            'failure'
        end    
    end
    
    def github_description
        GITHUB_DESCRIPTION[github_status]
    end
end
