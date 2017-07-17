class Response < ApplicationRecord
    belongs_to :commit
    belongs_to :url
    has_many :rules, dependent: :destroy
    include ResponsesHelper


    def color
        score >= 0 ? "green" : "red"
    end
end
