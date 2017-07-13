class Response < ApplicationRecord
    belongs_to :commit
    belongs_to :url
    has_many :rules, dependent: :destroy

    def color
        score >= 0 ? "green" : "red"
    end
end
