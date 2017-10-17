class Issue < ApplicationRecord
  acts_as_paranoid
  enum status: { keep: 0, problem: 1, try: 2 }
end
