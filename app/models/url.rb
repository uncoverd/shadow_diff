class Url < ApplicationRecord
    has_many :rules
    has_many :responses
end
