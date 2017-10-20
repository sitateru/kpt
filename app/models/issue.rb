class Issue < ApplicationRecord
  validates :title, presence: true
  enum status: { keep: 0, problem: 1, try: 2 }
end
