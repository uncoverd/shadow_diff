class Commit < ApplicationRecord
    has_many :responses

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
end
