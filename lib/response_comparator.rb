class ResponseComparator
    attr_reader :score

    def initialize(response, rules)
        @response = response
        @rules = rules
        @diff = nil
        @score = 0
    end

    def calculate_score
        indexes = diff_indexes
        ComparisonResult.where(response: @response).destroy_all
        @rules.each do |rule|
            indexes.each do |index|
                puts @diff[index] + " scores " + rule.evaluate(@diff[index]).to_s
                line_score = rule.evaluate(@diff[index])
                @score += line_score
                ComparisonResult.create(response: @response, rule: rule, index: index, line_score: line_score)
            end
        end
        score
    end

    def display_scoring
        #index pa ime pravila, ki je bil upoštevan
    end
    private

    def diff_indexes
        indexes = []
        @diff = Diffy::Diff.new(@response.production, @response.shadow).to_a#.each_chunk.to_a
        @diff.each_with_index do |line, index|
            if line[/^\+/] or line[/^-/]
                indexes << index
                puts line
            end
        end
        indexes  
    end
end    