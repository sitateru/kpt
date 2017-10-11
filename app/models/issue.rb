class Issue < ApplicationRecord
  enum status: { keep: 0, problem: 1, try: 2 }
end
