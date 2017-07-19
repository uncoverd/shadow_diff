class Rule < ApplicationRecord
  belongs_to :url
  belongs_to :commit
  belongs_to :response
  has_many :comparison_results, dependent: :destroy

  validates :name, presence: true
  validates :regex_string, presence: true
  validates :modifier, numericality: true

  MISSING_MODIFIER = -1

  enum status: [:active, :missing, :default]
  enum action: [:modify, :add, :remove]

  scope :active, -> { where(modifier: 0..Float::INFINITY) }


  def self.default_regexes
    [['ETag', 'ETag'], ['Set-Cookie', 'SetCookie'], ['X-Runtime', 'X-Runtime'], ['<meta content=(.)* name="csrf-token" />', "CSRF token"],
    ['CSRF form token',
    '    <form accept-charset=\"UTF-8\" action=\"/sessions\" method=\"post\"><div style=\"margin:0;padding:0;display:inline\"><input name=\"utf8\" type=\"hidden\" value=\"&#x2713;\" /><input name=\"authenticity_token\" type=\"hidden\" value=\"(.*?)\" /></div>'],
    ['X-View-Runtime', 'X-View-Runtime'],['X-Db-Runtime', 'X-Db-Runtime'],['X-Sql-Queries', 'X-Sql-Queries']]
  end   

  
end
