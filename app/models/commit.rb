class Commit < ApplicationRecord
    has_many :responses

    def update_scores
        responses.each do |response|
            comparator = ResponseComparator.new(response, Rule.where(commit: self, url: response.url))
            response.score = comparator.calculate_score
            response.save if response.changed?
        end
        self.score = responses.inject(0){|sum,x| sum + x.score }
        self.save
    end     
end
