class Rule < ApplicationRecord
  belongs_to :url
  belongs_to :commit

  enum status: [:active, :disabled]

  def evaluate(line)
      if line =~ regex
          modifier
      else
          0    
      end
  end

  private
  
  def regex
    Regex.new(regex_string)
  end 

end