class RuleEvaluator

    def initialize(rule)
        @rule = rule
    end

    PREFIXES = {  'add' => ['\+'],
                'remove' => ['\-'],
                'modify' => ['\+','\-']}

    LINE_CHANGES = {'add' => 1,
                    'remove' => 1,
                    'modify' => 2}

  def evaluate(lines)
    detected_prefixes = []
    detected_lines = []
  
    lines.each do |line|
      PREFIXES[@rule.action].each_with_index do |prefix, index|
        if line[regex(prefix)]
          detected_lines << line
          detected_prefixes[index] = true
        end  
      end 
    end

    if detected_prefixes.count(true) == LINE_CHANGES[@rule.action]
      [@rule.modifier, detected_lines]
    else
      [-1, []]
    end  
  end

  private

  def regex(prefix)
    Regexp.new(prefix + @rule.regex_string)
  end  

end    