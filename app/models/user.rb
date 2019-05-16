class User < ApplicationRecord
  # for soft delete
  acts_as_paranoid
  has_many :assignments # rubocop:disable Rails/HasManyOrHasOneDependent
  has_many :issues, through: :assignments

  validates :name, presence: true, uniqueness: { scope: :deleted_at }
  # not strictly
  validates :email, presence: true, format: { with: /\A[^@\s]+@[^@\s]+\z/ }
end
