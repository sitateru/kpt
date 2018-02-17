class User < ApplicationRecord
  # for soft delete
  acts_as_paranoid
  validates :name, presence: true, uniqueness: { scope: :deleted_at }
  # not strictly
  validates :email, presence: true, format: { with: /\A[^@\s]+@[^@\s]+\z/ }
end
