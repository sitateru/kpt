class Issue < ApplicationRecord
  acts_as_paranoid
  has_many :assignments # rubocop:disable Rails/HasManyOrHasOneDependent
  has_many :users, through: :assignments

  has_many :issue_tags, dependent: :destroy
  has_many :tags, through: :issue_tags

  validates :title, presence: true

  enum status: { keep: 0, problem: 1, try: 2 }
  # be able to search with string
  ransacker :status, formatter: proc { |v| statuses[v] }
end
