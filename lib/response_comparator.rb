class ResponseComparator
    attr_reader :score

    def initialize(response, rules)
        @response = response
        @rules = rules
        @diff = nil
        @score = 0
    end

    def calculate_score
        remove_previous_comparisons
        checked_lines = check_affected_lines
        check_missing_lines(changed_lines - checked_lines)
        @score
    end

    private

    def check_affected_lines
        affected_lines = []
        @rules.each do |rule|
            rule_evaluator = RuleEvaluator.new(rule)
            rule_score, lines = rule_evaluator.evaluate(changed_lines)
            if rule_score >= 0
                affected_lines += lines
                @score += rule_score
                ComparisonResult.create(response: @response, rule: rule, line_score: rule_score, line: lines.join("|||"))
                missing_rule = false
            end
        end
        affected_lines
    end

    def check_missing_lines(remaining_lines)
        remaining_lines.each do |line|
            create_comparison_result(line)
        end
    end    

    def remove_previous_comparisons
        ComparisonResult.where(response: @response).destroy_all
    end    

    def create_comparison_result(line)
        name = ''
        if line[0] == '+'
            action = :add
            name = 'Added'
        else
            action = :remove
            name = 'Removed'
        end        
        rule = Rule.create( modifier: Rule.missing_modifier, name: name, regex_string: "(?=a)b", url: @response.url,
                            commit: @response.commit, status: :missing, action: action, response: @response)  
        ComparisonResult.create(response: @response, rule: rule, line_score: rule.modifier, line: line)
        @score += rule.modifier
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