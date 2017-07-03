class ResponseComparator
    attr_reader :score

    def initialize(response, rules)
        @response = response
        @rules = rules
        @diff = nil
        @score = 0
    end

    def calculate_score
        lines = changed_lines
        ComparisonResult.where(response: @response).destroy_all
        lines.each do |line|
            missing_rule = true
            @rules.each do |rule|
                line_score = rule.evaluate(line)
                if line_score >= 0
                    @score += line_score
                    ComparisonResult.create(response: @response, rule: rule, line_score: line_score, line: line)
                    missing_rule = false
                end    
            end
            if missing_rule
                create_comparison_result(line)
            end    
        end
        @score
    end

    private

    def create_comparison_result(line)
        name = ''
        if line[0] == '+'
            name = 'Added'
        else
            name = 'Removed'
        end        
        rule = Rule.create(modifier: Rule.missing_modifier, name: name, regex_string: "", url: @response.url, commit: @response.commit, status: :missing)
        ComparisonResult.create(response: @response, rule: rule, line_score: Rule.missing_modifier, line: line)
        @score += Rule.missing_modifier
    end    

    def changed_lines
        lines = []
        diff = Diffy::Diff.new(@response.production, @response.shadow).to_a
        diff.each do |line|
            if line[/^\+/] or line[/^-/]
               lines << line
            end
        end
        lines  
    end
end    