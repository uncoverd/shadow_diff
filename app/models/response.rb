class Response < ApplicationRecord
    belongs_to :commit
    belongs_to :url
end
