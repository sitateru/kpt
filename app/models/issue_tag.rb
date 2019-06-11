class IssueTag < ApplicationRecord
  belongs_to :issue
  belongs_to :tag

  validates :tag_id, uniqueness: { scope: :issue_id }
end
