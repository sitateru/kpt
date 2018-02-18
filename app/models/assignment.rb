class Assignment < ApplicationRecord
  belongs_to :issue, -> { with_deleted }
  belongs_to :user, -> { with_deleted }

  validates :issue_id, uniqueness: { scope: :user_id }
end
