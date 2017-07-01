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
        @rules.each do |rule|
            indexes.each do |index|
                puts @diff[index] + " scores " + rule.evaluate(@diff[index]).to_s
                @score += rule.evaluate(@diff[index])
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
        @diff = Diffy::Diff.new(@response.production, @response.shadow).each_chunk.to_a
        @diff.each_with_index do |line, index|
            if line[/^\+/] or line[/^-/]
                indexes << index
            end
        end
        indexes  
    end
end    