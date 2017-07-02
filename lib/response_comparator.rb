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
        puts diff_indexes
        ComparisonResult.where(response: @response).destroy_all
        indexes.each do |index, line|
            missing_rule = true
            @rules.each do |rule|
                line_score = rule.evaluate(@diff[index])
                @score += line_score
                if line_score >= 0
                    ComparisonResult.create(response: @response, rule: rule,
                                        line_score: line_score, line: line)
                    missing_rule = false
                end    
            end
            if missing_rule
                create_missing_result(line)
            end    
        end
        score
    end

    private

    def create_missing_result(line)
        rule = Rule.create(modifier: -1, name: "Missing", regex_string: line, url: @response.url, commit: @response.commit)
        ComparisonResult.create(response: @response, rule: rule,
                                        line_score: -1, line: line)
    end    

    def diff_indexes
        indexes = []
        @diff = Diffy::Diff.new(@response.production, @response.shadow).to_a#.each_chunk.to_a
        @diff.each_with_index do |line, index|
            if line[/^\+/] #or line[/^-/]
                indexes << [index,line]
            end
        end
        indexes  
    end
end    