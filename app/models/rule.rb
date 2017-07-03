class Rule < ApplicationRecord
  belongs_to :url
  belongs_to :commit

  enum status: [:active, :missing, :default]

  def evaluate(line)
      if line[regex]
          modifier
      else
          -1    
      end
  end

  def self.default_regexes
    [['[+-]ETag', 'ETag'], ['[+-]Set-Cookie', 'SetCookie'], ['[+-]X-Runtime', 'X-Runtime'], ['<meta content=(.)* name="csrf-token" />', "CSRF token"]]
  end

  def self.missing_modifier
    -1
  end     

  private
  
  def regex
    Regexp.new(regex_string)
  end 

end
