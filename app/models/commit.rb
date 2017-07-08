class Commit < ApplicationRecord
    has_many :responses
    MIN_NUMBER_RESPONSES = 10

    def update_scores
        Rule.where(status: :missing).destroy_all
        responses.each do |response|
            comparator = ResponseComparator.new(response, Rule.where(commit: self, url: response.url, status: :active))
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
end
