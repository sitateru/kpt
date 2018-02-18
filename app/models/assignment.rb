class Assignment < ApplicationRecord
  belongs_to :issue
  belongs_to :user

  validates :issue_id, uniqueness: { scope: :user_id }
end
