class ComparisonResult < ApplicationRecord
  belongs_to :response
  belongs_to :rule
end
