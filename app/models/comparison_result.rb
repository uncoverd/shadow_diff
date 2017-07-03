class ComparisonResult < ApplicationRecord
  belongs_to :response
  belongs_to :rule

  def color
    line_score >= 0 ? "success" : "danger"
  end

  def display_line
    line.split('|||')
  end  

end
