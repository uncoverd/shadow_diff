class Rule < ApplicationRecord
  belongs_to :url
  belongs_to :commit

  enum status: [:active, :missing, :default]
  enum action: [:change, :add, :remove]

  PREFIXES = {  'add' => ['+'],
                'remove' => ['-'],
                'change' => ['+','-']}

  LINE_CHANGES = {  'add' => 1,
                    'remove' => 1,
                    'change' => 2}

  def evaluate(lines)
    detected_prefixes = []
    detected_lines = []
  
    lines.each do |line|
      PREFIXES[action].each_with_index do |prefix, index|
        if line[regex(prefix)]
          detected_lines << line
          detected_prefixes[index] = true
        end  
      end 
    end

    if detected_prefixes.count(true) == LINE_CHANGES[action]
      [modifier, detected_lines]
    else
      [-1, []]
    end  
  end

  def self.default_regexes
    [['ETag', 'ETag'], ['Set-Cookie', 'SetCookie'], ['X-Runtime', 'X-Runtime'], ['<meta content=(.)* name="csrf-token" />', "CSRF token"]]
  end

  def self.missing_modifier
    -1
  end     

  private
  
  def regex(prefix)
    Regexp.new(Regexp.escape(prefix + regex_string))
  end 

end
