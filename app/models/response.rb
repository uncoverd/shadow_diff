class Response < ApplicationRecord
    belongs_to :commit
    belongs_to :url

    def color
        score >= 0 ? "success" : "danger"
    end
end
