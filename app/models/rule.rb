class Rule < ApplicationRecord
  belongs_to :url
  belongs_to :commit
  belongs_to :response
  has_many :comparison_results

  validates :name, presence: true
  validates :regex_string, presence: true
  validates :modifier, numericality: true


  enum status: [:active, :missing, :default]
  enum action: [:modify, :add, :remove]

  def self.default_regexes
    [['ETag', 'ETag'], ['Set-Cookie', 'SetCookie'], ['X-Runtime', 'X-Runtime'], ['<meta content=(.)* name="csrf-token" />', "CSRF token"]]
  end

  def self.missing_modifier
    -1
  end     

  
end
