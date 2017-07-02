class Rule < ApplicationRecord
  belongs_to :url
  belongs_to :commit

  enum status: [:active, :disabled]

  def evaluate(line)
      if line =~ regex
          modifier
      else
          -1    
      end
  end

  private
  
  def regex
    Regexp.new(Regexp.escape(regex_string))
  end 

end
