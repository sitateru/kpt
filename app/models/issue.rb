class Issue < ApplicationRecord
  acts_as_paranoid
  validates :title, presence: true

  enum status: { keep: 0, problem: 1, try: 2 }
  # be able to search with string
  ransacker :status, formatter: proc { |v| statuses[v] }
end
