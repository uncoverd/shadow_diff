class Url < ApplicationRecord
    include UrlsHelper
    has_many :rules
    has_many :responses
end
