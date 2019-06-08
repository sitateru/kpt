class Tag < ApplicationRecord
  has_many :issue_tags, dependent: :destroy
  has_many :issues, through: :issue_tags

  validates :name, presence: true
end
